# 系統設計深度評審：WordPress -> Jekyll 遷移專案

最後更新：2026-05-08

## 1. 系統範圍與目標

本系統將 WordPress 匯出的內容檔案，轉換並部署為 GitHub Pages 上的 Jekyll 靜態網站。

主要目標：
- 以純檔案形式長期掌握內容資產。
- 保持可重現（deterministic）的靜態建置流程，降低維運成本。
- 以「無伺服器執行面」建立較強的安全與隱私基線。
- 透過 CI 的 Lighthouse 門檻維持品質。

非目標：
- 生產環境的動態 CMS 後台編輯。
- 執行期資料庫查詢。
- 使用者登入、個人化或線上寫入 API。

## 2. 高階架構

## 2.1 建置期流程（Build-Time Pipeline）
- 輸入來源：
  - WordPress XML：`my-site/import/leo.WordPress.2026-04-23.xml`
  - 本地媒體檔案：`my-site/assets/images/...`
- 轉換步驟：
  - `my-site/scripts/wordpress_to_jekyll.rb`
  - 產出 `_posts/YYYY-MM-DD-slug.md`（front matter + HTML 內容）。
  - 僅在本地檔案存在時才改寫圖片連結為 `relative_url`。
- 分類步驟：
  - `my-site/scripts/generate_category_pages.rb`
  - 產生 `my-site/category/*.markdown` 與 `my-site/categories.markdown`。
- 網站建置步驟：
  - `bundle exec jekyll build`

## 2.2 執行期模型（Static Delivery）
- 產物為靜態檔，由 GitHub Pages 提供服務。
- 無應用伺服器、無執行期資料庫。
- 前端增量行為：
  - 首頁「載入更多」互動。
  - PWA 基線所需的 Service Worker 註冊。

## 2.3 CI/CD 與品質門檻
- 部署流程：`.github/workflows/deploy-pages.yml`。
- Lighthouse 流程：`.github/workflows/lighthouse-ci.yml` + `.lighthouserc.json`。
- 品質檢核涵蓋：Performance、Accessibility、Best Practices、SEO。

## 3. 元件層級設計評審

## 3.1 內容轉換服務（`wordpress_to_jekyll.rb`）

職責：
- 安全解析 XML（拒絕 DOCTYPE/ENTITY）。
- 僅選取已發佈文章。
- 將 WordPress 欄位映射至 Jekyll front matter。
- 條件式改寫圖片 URL。
- 輸出 dry-run/write 統計與 unmatched URL 報告。

優點：
- 具備基本 XML 安全防護（XXE 相關風險降低）。
- 輸出路徑與圖片路徑有 traversal 防護。
- 檔名衝突採安全預設（跳過既有檔案）。

取捨：
- 跳過衝突可保護手動編輯，但不利於「同篇更新覆蓋」。
- URL 改寫仰賴 WordPress URL 規則，少數非常態連結可能不被匹配。

## 3.2 分類頁產生器（`generate_category_pages.rb`）

職責：
- 掃描所有文章 front matter 的 categories。
- 計算分類統計，產生分類頁與分類索引頁。

優點：
- 由內容源直接推導，輸出可重現。
- slug 衝突處理具決定性。

取捨：
- 每次全量掃描 `_posts`（以目前規模可接受）。
- 分類說明屬衍生資料，非手動策展 metadata。

## 3.3 首頁策展邏輯（`_layouts/home.html`）

職責：
- 組裝「封面故事」「編輯精選」「生活」「精選文章」。
- 應用 pinned titles 與主題優先規則。
- 透過前端漸進展開提升首頁可讀性。

優點：
- 兼具內容策展控制與自動化排序。
- 區塊間去重，降低重複曝光。

取捨：
- Liquid 模板邏輯較重，維護門檻提高。
- 行為可重現，但不如應用程式層 selector 容易測試。

## 4. 資料結構：選型理由、替代方案、取捨

## 4.1 持久化儲存：檔案系統階層
已選：
- 文章：`_posts` Markdown。
- 圖片：`assets/images/YYYY/MM/...`。

選用理由：
- 與 Jekyll 慣例高度一致。
- 版本控制友善（差異比較、審查、追溯）。
- 無執行期依賴，備份與遷移簡單。

替代方案：
- SQLite / 內容資料庫 + 靜態匯出。
- Headless CMS API 作為單一真實來源。

目前不採用原因：
- 增加基礎設施與平台耦合。
- 與「備份可攜、低維運」核心目標衝突。

## 4.2 Front Matter 結構：YAML 雜湊 + 陣列
已選：
- 單篇 metadata hash（`title`、`date`、`author`）+
  `categories`、`tags` 陣列。

選用理由：
- Jekyll 原生支援、可人工維護。
- 與 Liquid 聚合（分類、標籤）自然相容。

替代方案：
- 內容中嵌 JSON blob。
- 外部 metadata 索引檔。

取捨：
- YAML 彈性高但 schema 約束較弱。

## 4.3 分類統計：Ruby Hash Map
已選：
- `Hash<String, Integer>` 計數。

選用理由：
- 掃描期更新平均 O(1)。
- 實作簡單、效能與可讀性均衡。

替代方案：
- 純排序聚合（無 hash）。
- Tree/ordered map（強化在地化排序）。

取捨：
- 先 hash 後排序足夠快，但語系排序細節有限。

## 4.4 Liquid 去重資料結構：分隔字串模擬集合
已選：
- 使用 `|url|...` 形式累積，模擬 set membership。

選用理由：
- 在不加插件的 GitHub Pages 約束下可運作。
- 不需改動部署模型。

替代方案：
- 客製 Jekyll 插件提供集合操作。
- 先在建置腳本預算出清單寫入 `_data`。

取捨：
- 現行做法較冗長、可讀性較差。
- 預計算資料可改善維護性，但增加一個產物階段。

## 4.5 URL 改寫結構：Regex + URI 解析混合
已選：
- 先 regex 擷取 URL，再 URI parse + host/path 規則。

選用理由：
- 在混合 HTML 內容中具實務可行性。
- 同時保留一定語意驗證能力。

替代方案：
- 全量 HTML parser，僅改寫屬性級 URL。
- 在 XML 階段做 DOM 轉換。

取捨：
- Regex 可能多抓邊界符號，已用尾端標點剝離緩解。
- 全 DOM 方式語意更乾淨，但實作複雜度更高。

## 4.6 執行統計：Hash 計數器
已選：
- `Hash<Symbol, Integer>` 與 unmatched URL hash。

選用理由：
- 成本低、易理解、足夠支援人工操作流程。

替代方案：
- 結構化 JSON log events。
- SQLite run-history。

取捨：
- 現況報表可用，但缺乏長期趨勢分析能力。

## 5. 核心架構取捨

1. 靜態簡潔 vs 動態彈性
- 靜態模型降低維運與安全成本。
- 捨棄執行期個人化/查詢能力（需額外設計補足）。

2. 可重現建置 vs 模板複雜度
- 產物可重現、可追溯。
- 首頁 Liquid 規則增加維護與測試難度。

3. 安全遷移 vs 更新便利
- 檔名衝突跳過可防覆蓋。
- 同篇更新需明確操作（非自動覆寫）。

4. 插件最小化 vs 抽象能力
- 相容 GitHub Pages 限制。
- 限制了更乾淨的資料結構與語法表達。

## 6. 可擴展性與可靠性

現況評估：
- 數百篇文章在靜態建置上仍屬輕量。
- 圖片型資產可用，但 repo 成長會推高 clone/build 成本。

未來擴展選項：
- 文章量大幅成長時，將首頁策展前置到 `_data/*.yml`。
- 圖片量持續上升時，保留網頁優化圖於 repo，原圖移至物件儲存/CDN。

## 7. 安全與隱私評審

優勢：
- 無伺服器執行面，典型注入攻擊面顯著降低。
- XML 安全檢查已存在。
- 圖片改寫需本地檔案存在，降低誤改與壞連結風險。

殘餘風險：
- 歷史文章可能仍有外部連結或敏感資訊。
- 若敏感內容曾被 commit，Git 歷史仍可能保留痕跡。

建議強化：
- 在 CI 新增隱私掃描（email/phone/IP pattern）。
- pre-commit 秘密字串檢查。
- 定期連結與隱私稽核腳本。

## 8. 替代架構路徑

## Option A：維持現行架構（目前建議）
適用情境：
- 優先低維運、可重現、內容主權與備份可攜性。

## Option B：新增首頁策展預計算階段
改動：
- 將首頁規則前移為 Ruby 腳本，輸出 `_data/home.yml`。
優點：
- 模板更乾淨，規則可測試性提升。
缺點：
- 多一個產物與流程耦合點。

## Option C：靜態站 + 外部搜尋索引
改動：
- 保持靜態頁，外掛搜尋索引服務。
優點：
- 大量內容下查找體驗更好。
缺點：
- 新增整合與服務依賴。

## 9. Deep-Dive 問答準備（利害關係人會議版）

## Q1：為何選靜態檔而非資料庫型 CMS？
A：核心優先順序是內容主權、低維運、可重現建置與高可攜性，這些在靜態模型下成本最低。

## Q2：如何確保遷移安全？
A：XML 安全檢查、路徑 traversal 防護、檔名衝突跳過、dry-run 報表先驗證再寫入。

## Q3：為何衝突時跳過而不是覆寫？
A：避免覆蓋手動修訂內容。若要更新同篇，走明確更新流程更可控。

## Q4：為何採 host/path 規則改寫圖片？
A：可明確限制改寫範圍，避免誤動第三方 URL。

## Q5：為何保留 HTML-in-Markdown？
A：遷移以「無損」優先，避免 HTML->Markdown 轉換造成語意或排版回歸。

## Q6：為何分類頁用產生式而非執行期計算？
A：與無伺服器靜態架構一致，輸出穩定且部署單純。

## Q7：為何在 Liquid 用字串模擬 set？
A：在不加插件的 GitHub Pages 限制下，這是可部署且穩定的折衷。

## Q8：如果要提升維護性，第一個重構點是什麼？
A：把首頁選文規則抽到建置腳本，輸出 `_data/home.yml`，模板只負責呈現。

## Q9：如何防止品質倒退？
A：以 CI 內 Lighthouse 門檻 + 可重現 build 作為持續品質閘道。

## Q10：目前最大架構風險是什麼？
A：首頁 Liquid 邏輯複雜度，功能可行但可讀性與測試性不足。

## Q11：如何支援增量 XML 匯入更新？
A：可加入內容 fingerprint 與 update mode，僅覆寫可安全更新欄位。

## Q12：如何控制圖片造成的 repo 膨脹？
A：原圖分離存放（物件儲存/LFS），repo 保留 web 優化版本。

## Q13：如何再強化隱私治理？
A：CI 自動掃描 + allowlist + 新增敏感樣式即 fail 的策略。

## Q14：如何做更深的遷移正確性測試？
A：建立 golden fixtures、URL 改寫案例庫、front matter/body 差異斷言。

## Q15：PWA 壞掉會影響主服務嗎？
A：不會。內容交付核心仍是純靜態頁；PWA 屬增強能力。

## 10. 後續行動建議（依優先順序）

1. 首頁策展預計算化（`_data/home.yml`）。
2. CI 隱私掃描（posts/XML）。
3. 遷移腳本 fixture 測試（URL 改寫邊界案例）。
4. 補齊操作 runbook（匯入 -> 分類重建 -> 建置 -> 部署）。

