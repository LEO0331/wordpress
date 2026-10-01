import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import json

spec = importlib.util.spec_from_file_location("sync_wordpress", Path(__file__).parents[1] / "sync_wordpress.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def post(identity=1, slug="example"):
    return {"ID": identity, "slug": slug, "title": "Title &amp; test", "date": "2026-09-26T05:00:00+08:00", "modified": "2026-09-26T05:00:00+08:00", "author": {"login": "leo"}, "categories": {"test": {"name": "投資"}}, "tags": {}, "URL": "https://example.com/post", "content": "<p>Full post {{ example }}</p>", "status": "publish"}


class SyncTests(unittest.TestCase):
    def test_import_check_repeat_and_edit(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            item = post()
            self.assertEqual(module.sync([item], root, True)["added"], 1)
            self.assertFalse((root / "_posts").exists())
            self.assertEqual(module.sync([item], root)["added"], 1)
            path = next((root / "_posts").glob("*.md"))
            metadata = json.loads(path.read_text(encoding="utf-8").split("---")[1])
            self.assertEqual(metadata["categories"], ["投資"])
            self.assertEqual(metadata["date"], "2026-09-26 05:00:00+08:00")
            self.assertEqual(module.sync([item], root)["unchanged"], 1)
            item["slug"] = "renamed"
            item["content"] = "<p>Edited</p>"
            self.assertEqual(module.sync([item], root)["updated"], 1)
            self.assertEqual(len(list((root / "_posts").glob("*.md"))), 1)

    def test_preserve_legacy_and_removed_posts(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "_posts").mkdir()
            legacy = root / "_posts/2026-09-26-example.md"
            legacy.write_text("Original locally curated content")
            self.assertEqual(module.sync([post()], root)["preserved"], 1)
            module.sync([], root)
            self.assertEqual(legacy.read_text(), "Original locally curated content")

    def test_pagination_and_incomplete_response(self):
        pages = [json.dumps({"found": 2, "posts": [post(1)]}).encode(), json.dumps({"found": 2, "posts": [post(2)]}).encode()]
        with patch.object(module, "fetch", side_effect=pages):
            self.assertEqual(len(module.fetch_posts()), 2)
        with patch.object(module, "fetch", return_value=b'{"found":1,"posts":[]}'):
            with self.assertRaises(ValueError):
                module.fetch_posts()

    def test_image_download_and_rewrite(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content = '<img src="https://leolicheng.files.wordpress.com/2026/09/photo.jpg?w=100">'
            with patch.object(module, "fetch", return_value=b"image") as fetch:
                output = module.rewrite_images(content, root, False)
                self.assertIn("relative_url", output)
                self.assertEqual((root / "assets/images/2026/09/photo.jpg").read_bytes(), b"image")
                module.rewrite_images(content, root, False)
                self.assertEqual(fetch.call_count, 1)
                uploaded = content.replace("leolicheng.files.wordpress.com/", "leolicheng.wordpress.com/wp-content/uploads/")
                self.assertEqual(module.rewrite_images(uploaded, root, False), output)
                self.assertEqual(fetch.call_count, 1)


if __name__ == "__main__":
    unittest.main()
