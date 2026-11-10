---
{
  "layout": "post",
  "title": "Adelaide Uni CNA 網路概論複習筆記：",
  "date": "2026-10-03 10:43:00+08:00",
  "author": "leolicheng",
  "categories": [
    "程式設計"
  ],
  "tags": [],
  "wordpress_id": 1505,
  "wordpress_url": "https://leolicheng.wordpress.com/2026/10/03/adelaide-uni-cna-%e7%b6%b2%e8%b7%af%e6%a6%82%e8%ab%96%e8%a4%87%e7%bf%92%e7%ad%86%e8%a8%98%ef%bc%9a/",
  "wordpress_modified": "2026-10-19T19:36:30+08:00"
}
---

{% raw %}

<h2 class="wp-block-heading">解題思路</h2>



<p class="wp-block-paragraph">最近在整理以前念書留下來的資料，當時把 Application Layer、Transport Layer、Network Layer、Link Layer、Security 等內容拆開整理過，還留了一些筆記。CNA 這類課程範圍很大，DNS、HTTP、TCP、Routing、IP、Ethernet、Security 全部都會碰到。資料如果只是散落在 lecture slide、紙本考卷跟自己的筆記裡，考前其實很難知道到底該從哪裡開始。這篇乾脆把手上的<strong>考古題重新按照主題分類</strong>。不按照年份排，而是按照：</p>



<p class="wp-block-paragraph">Application Layer<br>Transport Layer<br>Network Layer / IP<br>Link Layer<br>ICMP / SNMP / Security</p>



<p class="wp-block-paragraph">每一題下面不直接塞完整標準答案，而是先放解題思路，這樣比較適合複習。現在有 AI，要查完整答案其實不難，比較有用的是看到題目之後，知道：</p>



<p class="wp-block-paragraph">這題是哪個章節？</p>



<p class="wp-block-paragraph">它想考哪個 concept？</p>



<p class="wp-block-paragraph">第一步應該想到什麼？</p>



<p class="wp-block-paragraph">哪些東西很容易搞混？</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">1. Application Layer</h1>



<p class="wp-block-paragraph">Application Layer 這三年重複率其實很高。</p>



<p class="wp-block-paragraph">大致可以再拆成：</p>



<p class="wp-block-paragraph">Network Delay、Client/Server vs P2P、DNS、HTTP、SMTP、Socket / Port。</p>



<h2 class="wp-block-heading">Network Delay</h2>



<h3 class="wp-block-heading">2013：列出兩種造成 Network Latency 的原因，並說明怎麼計算</h3>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">最基本先想到四種 nodal delay：</p>



<ul class="wp-block-list">
<li>Processing Delay</li>



<li>Queuing Delay</li>



<li>Transmission Delay</li>



<li>Propagation Delay</li>
</ul>



<p class="wp-block-paragraph">如果題目要求「計算」，最適合寫 Transmission 跟 Propagation。</p>



<p class="wp-block-paragraph">Transmission Delay：</p>



<p class="wp-block-paragraph"><code>L / R</code></p>



<p class="wp-block-paragraph">L 是 packet size，R 是 transmission rate。</p>



<p class="wp-block-paragraph">Propagation Delay：</p>



<p class="wp-block-paragraph"><code>D / S</code></p>



<p class="wp-block-paragraph">D 是距離，S 是訊號傳播速度。</p>



<p class="wp-block-paragraph">最重要的是不要把兩個搞反。</p>



<p class="wp-block-paragraph">Transmission Delay 跟距離無關。</p>



<p class="wp-block-paragraph">Propagation Delay 跟 packet size、bandwidth 無關。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h3 class="wp-block-heading">2013：10 GB 影片，用 2 Mb/s Internet 傳還是燒 DVD 寄 24 小時比較快？</h3>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">這種題目數學沒有很難，真正容易錯的是單位。</p>



<p class="wp-block-paragraph">先把 Byte 換成 bit：</p>



<p class="wp-block-paragraph"><code>10 GB × 8</code></p>



<p class="wp-block-paragraph">再除以：</p>



<p class="wp-block-paragraph"><code>2 Mb/s</code></p>



<p class="wp-block-paragraph">最後把秒換成小時，再跟 24 小時比較。</p>



<p class="wp-block-paragraph">這類題目一定要把 calculation 寫出來，不能只猜 Internet 比較快。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h3 class="wp-block-heading">2014：Propagation Delay 跟 Transmission Delay 是什麼？另外兩種 delay 是什麼？</h3>



<p class="wp-block-paragraph">這算是上面 2013 題目的變形。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Propagation：</p>



<p class="wp-block-paragraph"><code>distance / propagation speed</code></p>



<p class="wp-block-paragraph">Transmission：</p>



<p class="wp-block-paragraph"><code>packet length / transmission rate</code></p>



<p class="wp-block-paragraph">另外兩個：</p>



<p class="wp-block-paragraph">Processing Delay<br>Queuing Delay</p>



<p class="wp-block-paragraph">這四個最好直接當成一組記。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h3 class="wp-block-heading">2015：IP over Avian Carrier</h3>



<p class="wp-block-paragraph">這題很有趣。</p>



<p class="wp-block-paragraph">假設用鴿子帶兩顆 128GB flash drive，給你：</p>



<p class="wp-block-paragraph">寫入速度<br>讀取速度<br>鴿子飛行速度<br>Adelaide 到 Rio 的距離<br>檔案大小</p>



<p class="wp-block-paragraph">要求算總 delay。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">不要看到鴿子就亂掉。</p>



<p class="wp-block-paragraph">它本質上還是一題：</p>



<p class="wp-block-paragraph">Transmission Delay + Propagation Delay。</p>



<p class="wp-block-paragraph">寫 flash drive 是 transmission。</p>



<p class="wp-block-paragraph">鴿子飛行是 propagation。</p>



<p class="wp-block-paragraph">目的地讀 flash drive 又是一段 transmission。</p>



<p class="wp-block-paragraph">所以：</p>



<p class="wp-block-paragraph"><code>總時間 = 寫入時間 + 飛行時間 + 讀取時間</code></p>



<p class="wp-block-paragraph">第二小題再問：</p>



<p class="wp-block-paragraph">什麼情況下 Avian Carrier 的 transmission delay 或 propagation delay 可能比 Internet 低？</p>



<p class="wp-block-paragraph">這時就不是算數字，而是在比較：</p>



<p class="wp-block-paragraph">data rate<br>distance<br>propagation speed</p>



<p class="wp-block-paragraph">這是一個很好理解 Transmission 跟 Propagation 差別的題目。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Client/Server vs P2P</h1>



<h3 class="wp-block-heading">2013：什麼條件下 Client/Server distributing file 可能比 P2P 快？</h3>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">不要直接回答「P2P 比較快」。</p>



<p class="wp-block-paragraph">先看 bottleneck 在哪。</p>



<p class="wp-block-paragraph">Client/Server 主要受：</p>



<p class="wp-block-paragraph">Server upload bandwidth<br>Slowest client download bandwidth</p>



<p class="wp-block-paragraph">限制。</p>



<p class="wp-block-paragraph">P2P 則除了 Server upload，還多了所有 peer 的 upload capacity。</p>



<p class="wp-block-paragraph">所以應該從：</p>



<p class="wp-block-paragraph">Server 很快嗎？</p>



<p class="wp-block-paragraph">Peer 的 upload capacity 高不高？</p>



<p class="wp-block-paragraph">Peer 數量多少？</p>



<p class="wp-block-paragraph">Slowest peer download 是不是 bottleneck？</p>



<p class="wp-block-paragraph">這幾個方向比較。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h3 class="wp-block-heading">2014：解釋 P2P Distribution Time Formula</h3>



<p class="wp-block-paragraph">題目會看到：</p>



<p class="wp-block-paragraph"><code>F / us</code></p>



<p class="wp-block-paragraph"><code>F / dmin</code></p>



<p class="wp-block-paragraph"><code>NF / (us + Σui)</code></p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">不要死背式子。</p>



<p class="wp-block-paragraph">逐項翻成中文。</p>



<p class="wp-block-paragraph"><code>F / us</code></p>



<p class="wp-block-paragraph">Server 至少要有能力 upload 一份完整 file 所需要的時間。</p>



<p class="wp-block-paragraph"><code>F / dmin</code></p>



<p class="wp-block-paragraph">最慢的 peer 下載一份完整 file 所需要的時間。</p>



<p class="wp-block-paragraph"><code>NF / (us + Σui)</code></p>



<p class="wp-block-paragraph">總共有 N 份 file 要送出去，而整個系統可用的 upload capacity 是 server 加上所有 peers。</p>



<p class="wp-block-paragraph">最後取：</p>



<p class="wp-block-paragraph"><code>max(...)</code></p>



<p class="wp-block-paragraph">因為整體時間至少不能低於其中最慢的限制。</p>



<p class="wp-block-paragraph">Client/Server 則是：</p>



<p class="wp-block-paragraph"><code>max(NF/us, F/dmin)</code></p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h3 class="wp-block-heading">2015：P2P 一定比 Client/Server 快或一樣快嗎？</h3>



<p class="wp-block-paragraph">題目是 True / False。</p>



<p class="wp-block-paragraph">在題目給的理想模型裡，Server 本身也參與 P2P。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">直接比較兩條公式。</p>



<p class="wp-block-paragraph">Client/Server：</p>



<p class="wp-block-paragraph"><code>max(NF/us, F/dmin)</code></p>



<p class="wp-block-paragraph">P2P：</p>



<p class="wp-block-paragraph"><code>max(F/us, F/dmin, NF/(us + Σui))</code></p>



<p class="wp-block-paragraph">因為 P2P 多了 peer 的 upload capacity，所以在這個 model 下，P2P 的最低 distribution time 不會比 Client/Server 差。</p>



<p class="wp-block-paragraph">重點是：</p>



<p class="wp-block-paragraph"><strong>答案成立是因為題目給的 model。</strong></p>



<p class="wp-block-paragraph">不是代表現實世界所有 P2P application 永遠比較快。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">DNS</h1>



<p class="wp-block-paragraph">DNS 是三年都有出現的重點。</p>



<h2 class="wp-block-heading">2013：DNS iterative query 裡 caching 怎麼運作？</h2>



<p class="wp-block-paragraph">題目要求分：</p>



<p class="wp-block-paragraph">Local Host<br>Local DNS<br>Root DNS<br>TLD DNS<br>Authoritative DNS</p>



<p class="wp-block-paragraph">討論 cached information。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">先把 DNS resolution 畫出來：</p>



<p class="wp-block-paragraph">Host<br>→ Local DNS<br>→ Root<br>→ TLD<br>→ Authoritative DNS</p>



<p class="wp-block-paragraph">再想每一層拿到什麼 mapping。</p>



<p class="wp-block-paragraph">DNS cache 的目的就是：</p>



<p class="wp-block-paragraph">下次遇到相同或相關 query 時，不用重新一路找到 root。</p>



<p class="wp-block-paragraph">也要記得 TTL。</p>



<p class="wp-block-paragraph">Cache 不是永久有效。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Local DNS 沒有 <a href="http://www.mycom.com.au" rel="nofollow">http://www.mycom.com.au</a> 的 cache，要怎麼找到 IP？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">這是一題標準 DNS resolution 流程。</p>



<p class="wp-block-paragraph">大方向：</p>



<p class="wp-block-paragraph">Local DNS 查 cache。</p>



<p class="wp-block-paragraph">沒有。</p>



<p class="wp-block-paragraph">詢問 Root DNS。</p>



<p class="wp-block-paragraph">Root 指向 <code>.au</code> / 對應 TLD DNS。</p>



<p class="wp-block-paragraph">TLD 再告訴你 authoritative DNS。</p>



<p class="wp-block-paragraph">Local DNS 找 authoritative DNS。</p>



<p class="wp-block-paragraph">取得 A record / IP address。</p>



<p class="wp-block-paragraph">回給 client。</p>



<p class="wp-block-paragraph">實際答題時最好按照順序畫箭頭。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：為什麼 iterative DNS query 通常比 recursive query 好？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">主要想 scalability。</p>



<p class="wp-block-paragraph">Recursive query 代表被問的 DNS server 要繼續替 client 找完整答案。</p>



<p class="wp-block-paragraph">如果每一層都這樣做，server 要維護更多工作與狀態。</p>



<p class="wp-block-paragraph">Iterative 的做法是：</p>



<p class="wp-block-paragraph">「我不知道完整答案，但我告訴你下一個該問誰。」</p>



<p class="wp-block-paragraph">因此可以降低高層 DNS server 的負擔，也比較 scalable。</p>



<p class="wp-block-paragraph">Caching 也會進一步降低 Root / TLD 被查詢的頻率。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">HTTP</h1>



<h2 class="wp-block-heading">2013：HTTP/1.1 Persistent Connection 為什麼改善 performance？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">先比較：</p>



<p class="wp-block-paragraph">Non-persistent HTTP：</p>



<p class="wp-block-paragraph">每個 object 都可能重新建立 TCP connection。</p>



<p class="wp-block-paragraph">因此要多付：</p>



<p class="wp-block-paragraph">TCP handshake RTT<br>HTTP request / response RTT</p>



<p class="wp-block-paragraph">另外重新建立 TCP connection，也可能重新開始 congestion-control 的成長過程。</p>



<p class="wp-block-paragraph">Persistent connection 可以重複利用同一條 TCP connection。</p>



<p class="wp-block-paragraph">所以：</p>



<p class="wp-block-paragraph">少 handshake<br>少 RTT<br>少 connection setup overhead</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Persistent Connection 怎麼降低 Web Page Latency？</h2>



<p class="wp-block-paragraph">跟 2013 很像。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">一個 HTML page 通常不只有 HTML。</p>



<p class="wp-block-paragraph">還有：</p>



<p class="wp-block-paragraph">CSS<br>JavaScript<br>Images<br>其他 objects</p>



<p class="wp-block-paragraph">如果每一個 object 都建立一次 TCP connection，成本很高。</p>



<p class="wp-block-paragraph">Persistent HTTP 可以在同一條 connection 上繼續 request objects。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：HTTP 有哪些降低 latency 的技術？</h2>



<p class="wp-block-paragraph">可以從當時課程內容想到：</p>



<p class="wp-block-paragraph">Persistent Connection<br>Pipelining<br>Web Cache / Proxy</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Persistent Connection：</p>



<p class="wp-block-paragraph">減少 connection setup。</p>



<p class="wp-block-paragraph">Pipelining：</p>



<p class="wp-block-paragraph">不用等上一個 request 完整 response 回來才送下一個。</p>



<p class="wp-block-paragraph">Caching：</p>



<p class="wp-block-paragraph">如果附近 cache 已經有 object，就不用每次回 origin server。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">SMTP</h1>



<h2 class="wp-block-heading">2013：為什麼 SMTP Server 不要求所有 sender authentication 才收信？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">先分清楚：</p>



<p class="wp-block-paragraph">User authentication</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">Internet mail server 之間交換郵件</p>



<p class="wp-block-paragraph">不是完全同一件事。</p>



<p class="wp-block-paragraph">如果一個 mail server 只接受自己認識、可以 authentication 的 sender，其他 Internet domain 的 mail server 就很難把郵件寄進來。</p>



<p class="wp-block-paragraph">這題想問的是 Internet email 為什麼不能單純靠「全部先登入」解決信任問題。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Protocol Syntax</h1>



<h2 class="wp-block-heading">2015：Text-based protocol 怎麼知道一個 message 到哪裡結束？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">常見方式有：</p>



<p class="wp-block-paragraph">Length field / Content-Length</p>



<p class="wp-block-paragraph">或者：</p>



<p class="wp-block-paragraph">特殊 delimiter / terminator</p>



<p class="wp-block-paragraph">例如 SMTP 類似：</p>



<p class="wp-block-paragraph"><code>CRLF.CRLF</code></p>



<p class="wp-block-paragraph">另外 connection close 本身也可以用來表示 message end。</p>



<p class="wp-block-paragraph">題目只要求兩種，重點是理解：</p>



<p class="wp-block-paragraph">Protocol 除了定義內容，也必須定義 message framing。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Socket / Port</h1>



<h2 class="wp-block-heading">2014：同一台電腦開兩個 browser window，連同一台 Web Server，兩條 TCP connection 怎麼區分？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">TCP connection 看的是 4-tuple：</p>



<p class="wp-block-paragraph">Source IP<br>Source Port<br>Destination IP<br>Destination Port</p>



<p class="wp-block-paragraph">兩個 browser connection 可以：</p>



<p class="wp-block-paragraph">Source IP 相同<br>Destination IP 相同<br>Destination Port 都是 HTTP port</p>



<p class="wp-block-paragraph">但：</p>



<p class="wp-block-paragraph">Source Port 不同</p>



<p class="wp-block-paragraph">因此還是兩條不同 TCP connections。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">2. Transport Layer</h1>



<p class="wp-block-paragraph">Transport Layer 是這三年最值得練的部分之一。</p>



<p class="wp-block-paragraph">核心幾乎都圍繞：</p>



<p class="wp-block-paragraph">Reliable Transport<br>GBN / SR<br>TCP Congestion Control<br>Flow Control<br>RTT / Timeout<br>Connection Establishment</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Go-Back-N / Selective Repeat</h1>



<h2 class="wp-block-heading">2013：GBN 最少需要多少 Sequence Numbers？</h2>



<p class="wp-block-paragraph">如果 sender window size 是 W：</p>



<p class="wp-block-paragraph">GBN 至少需要：</p>



<p class="wp-block-paragraph"><code>W + 1</code></p>



<p class="wp-block-paragraph">個 sequence numbers。</p>



<p class="wp-block-paragraph"><strong>思路：</strong></p>



<p class="wp-block-paragraph">Sequence number 不能太快 wrap around，否則 sender / receiver 可能無法分辨：</p>



<p class="wp-block-paragraph">新的 packet</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">之前延遲或重送的 packet。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2013：Selective Repeat 最少需要多少 Sequence Numbers？</h2>



<p class="wp-block-paragraph">SR 的 sequence number space 至少：</p>



<p class="wp-block-paragraph"><code>2W</code></p>



<p class="wp-block-paragraph">也就是：</p>



<p class="wp-block-paragraph"><code>Window Size &lt;= Sequence Number Space / 2</code></p>



<p class="wp-block-paragraph"><strong>思路：</strong></p>



<p class="wp-block-paragraph">因為 SR receiver 會接受並 buffer out-of-order packets。</p>



<p class="wp-block-paragraph">如果 sequence number 太快重複，receiver 可能把舊 packet 誤認成新 packet。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Alternating Bit、GBN、SR Receiver Buffer 要多少？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Alternating Bit：</p>



<p class="wp-block-paragraph">一次只處理一個 outstanding packet。</p>



<p class="wp-block-paragraph">Receiver buffer requirement 很小。</p>



<p class="wp-block-paragraph">GBN：</p>



<p class="wp-block-paragraph">Receiver 通常只接受下一個 expected packet，out-of-order packet 丟掉，所以 receiver buffer 也可以很簡單。</p>



<p class="wp-block-paragraph">SR：</p>



<p class="wp-block-paragraph">會保存 window 內 out-of-order packets，因此需要比較大的 receiver buffer。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：三種 Reliable Transport 各自的優點？</h2>



<p class="wp-block-paragraph">Alternating Bit：</p>



<p class="wp-block-paragraph">最簡單。</p>



<p class="wp-block-paragraph">GBN：</p>



<p class="wp-block-paragraph">可以 pipeline，而且 receiver implementation 簡單。</p>



<p class="wp-block-paragraph">Selective Repeat：</p>



<p class="wp-block-paragraph">只重傳真正遺失或錯誤的 packet，在 loss 高的環境比較有效率。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：High Error Rate 時哪一個表現最好？</h2>



<p class="wp-block-paragraph">通常想到：</p>



<p class="wp-block-paragraph">Selective Repeat。</p>



<p class="wp-block-paragraph">原因不是因為它「比較新」。</p>



<p class="wp-block-paragraph">而是：</p>



<p class="wp-block-paragraph">GBN 一個 packet 出錯，後面很多已經正確收到的 packet 可能也要重新傳。</p>



<p class="wp-block-paragraph">SR 只 retransmit 真正有問題的 packet。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Bandwidth-Delay Product / Window</h1>



<h2 class="wp-block-heading">2013：RTT 50 ms、Bandwidth 1 Gb/s，要多大的 Window 才不會退化成 Stop-and-Wait？</h2>



<p class="wp-block-paragraph">核心概念：</p>



<p class="wp-block-paragraph"><code>Bandwidth × RTT</code></p>



<p class="wp-block-paragraph">也就是 Bandwidth-Delay Product。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Window 必須大到足以讓 sender 在等待第一個 ACK 回來之前，持續把 link 填滿。</p>



<p class="wp-block-paragraph">如果 window 太小：</p>



<p class="wp-block-paragraph">送完 window<br>→ 等 ACK<br>→ link idle</p>



<p class="wp-block-paragraph">就浪費 bandwidth。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">TCP Congestion Control</h1>



<p class="wp-block-paragraph">這也是連續三年重點。</p>



<h2 class="wp-block-heading">2013：為什麼 TCP 到 threshold 後，從 exponential growth 變成 linear growth？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Slow Start 一開始不知道 network capacity。</p>



<p class="wp-block-paragraph">所以快速增加 cwnd。</p>



<p class="wp-block-paragraph">一旦接近之前估計可能造成 congestion 的區域，就不能繼續 aggressive doubling。</p>



<p class="wp-block-paragraph">因此：</p>



<p class="wp-block-paragraph">Slow Start：</p>



<p class="wp-block-paragraph">Exponential increase</p>



<p class="wp-block-paragraph">接近 <code>ssthresh</code>：</p>



<p class="wp-block-paragraph">轉 Congestion Avoidance</p>



<p class="wp-block-paragraph">Additive / Linear increase</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：沒有 Congestion Control，什麼情況會發生 congestion？</h2>



<p class="wp-block-paragraph">不要只寫：</p>



<p class="wp-block-paragraph">Too much traffic。</p>



<p class="wp-block-paragraph">題目特別要求要講 router / link resource。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">如果：</p>



<p class="wp-block-paragraph">Packets arriving at router 的速度</p>



<p class="wp-block-paragraph">大於：</p>



<p class="wp-block-paragraph">Outgoing link 可以送出去的速度</p>



<p class="wp-block-paragraph">queue 就會開始累積。</p>



<p class="wp-block-paragraph">Router buffer 有限。</p>



<p class="wp-block-paragraph">最後：</p>



<p class="wp-block-paragraph">Buffer full<br>→ packet drop<br>→ retransmission<br>→ 更多 traffic</p>



<p class="wp-block-paragraph">問題可能越來越嚴重。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014 / 2015：詳細說明 TCP Congestion Control</h2>



<p class="wp-block-paragraph">複習至少要掌握：</p>



<p class="wp-block-paragraph">Congestion Window <code>cwnd</code></p>



<p class="wp-block-paragraph">Slow Start</p>



<p class="wp-block-paragraph"><code>ssthresh</code></p>



<p class="wp-block-paragraph">Congestion Avoidance</p>



<p class="wp-block-paragraph">Timeout</p>



<p class="wp-block-paragraph">Three Duplicate ACKs</p>



<p class="wp-block-paragraph">Fast Retransmit</p>



<p class="wp-block-paragraph">Fast Recovery</p>



<p class="wp-block-paragraph">基本思路就是：</p>



<p class="wp-block-paragraph">沒有 congestion 時逐步提高 sending rate。</p>



<p class="wp-block-paragraph">偵測到 loss 後降低 rate。</p>



<p class="wp-block-paragraph">TCP 不直接知道整個 network 的 capacity，而是透過 ACK、loss、timeout 等訊號推測 network 狀態。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：為什麼 Three Duplicate ACKs 跟 Timeout 代表的情況不完全一樣？</h2>



<p class="wp-block-paragraph">收到 duplicate ACK，表示：</p>



<p class="wp-block-paragraph">後面的 segment 還有成功到 receiver。</p>



<p class="wp-block-paragraph">也就是 network 還有持續傳 packet。</p>



<p class="wp-block-paragraph">所以 loss 可能只是一個局部 packet loss。</p>



<p class="wp-block-paragraph">Timeout 則通常代表情況比較嚴重。</p>



<p class="wp-block-paragraph">因此 TCP 對兩種 event 的 reaction 不完全相同。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">RTT / Timeout</h1>



<h2 class="wp-block-heading">2014：為什麼 Timeout 不能只使用 Estimated RTT，還要加 Estimated Deviation？</h2>



<p class="wp-block-paragraph">基本概念：</p>



<p class="wp-block-paragraph"><code>TimeoutInterval = EstimatedRTT + safety margin</code></p>



<p class="wp-block-paragraph">而 safety margin 跟 RTT variation 有關。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">如果 network RTT 很穩：</p>



<p class="wp-block-paragraph">margin 不需要太大。</p>



<p class="wp-block-paragraph">如果 RTT 波動很大：</p>



<p class="wp-block-paragraph">Timeout 也應該增加。</p>



<p class="wp-block-paragraph">如果完全不考慮 deviation，很容易：</p>



<p class="wp-block-paragraph">packet 只是比較慢</p>



<p class="wp-block-paragraph">就被錯誤判定為 lost</p>



<p class="wp-block-paragraph">造成 unnecessary retransmission。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">TCP Flow Control</h1>



<h2 class="wp-block-heading">2013：除了 Congestion Control，還有什麼會限制 TCP Sending Rate？</h2>



<p class="wp-block-paragraph">Flow Control。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Congestion Control 保護：</p>



<p class="wp-block-paragraph">Network。</p>



<p class="wp-block-paragraph">Flow Control 保護：</p>



<p class="wp-block-paragraph">Receiver。</p>



<p class="wp-block-paragraph">Receiver 透過 Receive Window 告訴 sender：</p>



<p class="wp-block-paragraph">「我還剩多少 buffer。」</p>



<p class="wp-block-paragraph">Sender 要確保 outstanding data 不超過 receiver 可接受範圍。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Receiver 怎麼把剩餘 buffer 告訴 Sender？</h2>



<p class="wp-block-paragraph">TCP header 裡的：</p>



<p class="wp-block-paragraph">Receive Window。</p>



<p class="wp-block-paragraph">也就是 <code>rwnd</code>。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：如果 Receive Window = 0，Sender 不再送資料，那 Receiver 之後 buffer 有空間時怎麼通知 Sender？</h2>



<p class="wp-block-paragraph">這是 TCP 的 Zero Window 問題。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Sender 不能永遠什麼都不送。</p>



<p class="wp-block-paragraph">可以使用：</p>



<p class="wp-block-paragraph">Persist Timer / Zero Window Probe</p>



<p class="wp-block-paragraph">偶爾送小 probe。</p>



<p class="wp-block-paragraph">Receiver 就會回 ACK，並附上最新的 Receive Window。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Multiplexing / Demultiplexing</h1>



<h2 class="wp-block-heading">2014：Transport Layer Multiplexing / Demultiplexing 是做什麼？</h2>



<p class="wp-block-paragraph">Multiplexing：</p>



<p class="wp-block-paragraph">把不同 application process 的資料交給 transport layer。</p>



<p class="wp-block-paragraph">Demultiplexing：</p>



<p class="wp-block-paragraph">收到 segment 後，把它交給正確 application/socket。</p>



<p class="wp-block-paragraph">UDP 主要根據 destination port。</p>



<p class="wp-block-paragraph">TCP connection 則通常透過：</p>



<p class="wp-block-paragraph">Source IP<br>Source Port<br>Destination IP<br>Destination Port</p>



<p class="wp-block-paragraph">來區分。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">TCP Connection</h1>



<h2 class="wp-block-heading">2013：為什麼 TCP 4-Way Termination 不能 100% 保證雙方同時知道 connection 已關閉？</h2>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Network packet 可能遺失。</p>



<p class="wp-block-paragraph">包括最後的 ACK。</p>



<p class="wp-block-paragraph">所以永遠存在：</p>



<p class="wp-block-paragraph">A 覺得結束了</p>



<p class="wp-block-paragraph">B 還沒收到最後確認</p>



<p class="wp-block-paragraph">的可能。</p>



<p class="wp-block-paragraph">TCP 使用：</p>



<p class="wp-block-paragraph">Timeout<br>Retransmission<br>TIME_WAIT</p>



<p class="wp-block-paragraph">盡量降低這個問題。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：為什麼只用 Two-Way Handshake 可能造成 Half-Open Connection？</h2>



<p class="wp-block-paragraph">想像：</p>



<p class="wp-block-paragraph">舊的 connection request 在 network 裡延遲很久。</p>



<p class="wp-block-paragraph">之後突然到 server。</p>



<p class="wp-block-paragraph">Server 如果只需要：</p>



<p class="wp-block-paragraph">Request<br>Response</p>



<p class="wp-block-paragraph">就認為 connection 成立，</p>



<p class="wp-block-paragraph">可能 server 覺得 connection 已建立，但 client 根本沒有這條 connection。</p>



<p class="wp-block-paragraph">Three-Way Handshake 多一次確認，就是為了確認雙方都真的知道現在這個 connection。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">3. Network Layer / Routing / Internet Protocol</h1>



<p class="wp-block-paragraph">這一區主要分：</p>



<p class="wp-block-paragraph">Dijkstra / Link State<br>Distance Vector<br>IP Address / Subnetting<br>IPv4 / IPv6<br>Fragmentation<br>Forwarding</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Link State / Dijkstra</h1>



<h2 class="wp-block-heading">2013：舉一個 Link State Routing Protocol</h2>



<p class="wp-block-paragraph">最直接：</p>



<p class="wp-block-paragraph">OSPF。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Dijkstra Algorithm Complexity</h2>



<p class="wp-block-paragraph">題目給：</p>



<p class="wp-block-paragraph"><code>O(n²)</code></p>



<p class="wp-block-paragraph">跟：</p>



<p class="wp-block-paragraph"><code>O(n log n)</code></p>



<p class="wp-block-paragraph">兩種 implementation。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">如果每一輪都線性掃描所有 node 找 minimum：</p>



<p class="wp-block-paragraph">大致會得到 <code>O(n²)</code>。</p>



<p class="wp-block-paragraph">如果使用 priority queue / heap：</p>



<p class="wp-block-paragraph">找最小值與更新成本可以下降，因此可做到更好的 complexity。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：用 Dijkstra 建立 Node A Routing Table</h2>



<p class="wp-block-paragraph">這種題目一定要真的練紙筆。</p>



<p class="wp-block-paragraph">基本流程：</p>



<p class="wp-block-paragraph">起點 A cost = 0。</p>



<p class="wp-block-paragraph">其他都是 infinity。</p>



<p class="wp-block-paragraph">每次選目前尚未確定、cost 最小的 node。</p>



<p class="wp-block-paragraph">固定它。</p>



<p class="wp-block-paragraph">Relax 它的 neighbours。</p>



<p class="wp-block-paragraph">重複。</p>



<p class="wp-block-paragraph">最後 Routing Table 要列：</p>



<p class="wp-block-paragraph">Destination<br>Next Hop<br>Total Path Cost</p>



<p class="wp-block-paragraph">不要只寫最短距離，因為題目通常還要 next hop。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Distance Vector</h1>



<h2 class="wp-block-heading">2013 / 2015：收到 Neighbor 的 Distance Vector 後更新 Table</h2>



<p class="wp-block-paragraph">核心：</p>



<p class="wp-block-paragraph">Bellman-Ford。</p>



<p class="wp-block-paragraph">從 A 到 destination x，如果經過 neighbour B：</p>



<p class="wp-block-paragraph"><code>Cost(A,x via B) = Cost(A,B) + Cost(B,x)</code></p>



<p class="wp-block-paragraph">對每一個 neighbour 算完後：</p>



<p class="wp-block-paragraph">選 minimum。</p>



<p class="wp-block-paragraph">2015 還多問：</p>



<p class="wp-block-paragraph">更新後要不要送新的 vector？</p>



<p class="wp-block-paragraph">判斷方式就是：</p>



<p class="wp-block-paragraph">自己的 best distance 是否發生變化。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">IP Address / Subnetting</h1>



<h2 class="wp-block-heading">2013：223.1.3.27 轉 Binary</h2>



<p class="wp-block-paragraph">純粹考：</p>



<p class="wp-block-paragraph">Decimal ↔ Binary。</p>



<p class="wp-block-paragraph">每個 octet 8 bits。</p>



<p class="wp-block-paragraph">建議自己熟：</p>



<p class="wp-block-paragraph">128 64 32 16 8 4 2 1</p>



<p class="wp-block-paragraph">比硬背答案有用。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2013：223.1.17.0/24 要切三個 Subnet</h2>



<p class="wp-block-paragraph">條件：</p>



<p class="wp-block-paragraph">Subnet 1 要 125 hosts。</p>



<p class="wp-block-paragraph">Subnet 2、3 各 60 hosts。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">125 hosts：</p>



<p class="wp-block-paragraph">至少要 7 host bits。</p>



<p class="wp-block-paragraph"><code>2^7 - 2 = 126</code></p>



<p class="wp-block-paragraph">所以可以用 <code>/25</code>。</p>



<p class="wp-block-paragraph">60 hosts：</p>



<p class="wp-block-paragraph">至少 6 host bits。</p>



<p class="wp-block-paragraph"><code>2^6 - 2 = 62</code></p>



<p class="wp-block-paragraph">所以可以用 <code>/26</code>。</p>



<p class="wp-block-paragraph">一個可行切法：</p>



<p class="wp-block-paragraph">223.1.17.0/25</p>



<p class="wp-block-paragraph">223.1.17.128/26</p>



<p class="wp-block-paragraph">223.1.17.192/26</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：同一批 IP 在沒有 prefix、/16、/24 時分別有幾個 Network？</h2>



<p class="wp-block-paragraph">這題很適合確認自己是真的懂 prefix。</p>



<p class="wp-block-paragraph">沒有 CIDR prefix 的舊式 Classful 判斷，10.x.x.x 是 Class A。</p>



<p class="wp-block-paragraph">加 <code>/16</code>：</p>



<p class="wp-block-paragraph">比較前 16 bits。</p>



<p class="wp-block-paragraph">加 <code>/24</code>：</p>



<p class="wp-block-paragraph">比較前 24 bits。</p>



<p class="wp-block-paragraph">不要靠「看起來很像」。</p>



<p class="wp-block-paragraph">真正做法永遠是：</p>



<p class="wp-block-paragraph">IP address AND subnet mask。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：223.1.3.27/16 的 Network Address Binary 是什麼？</h2>



<p class="wp-block-paragraph">先做：</p>



<p class="wp-block-paragraph"><code>223.1.3.27 AND 255.255.0.0</code></p>



<p class="wp-block-paragraph">得到：</p>



<p class="wp-block-paragraph">223.1.0.0</p>



<p class="wp-block-paragraph">再轉成 binary。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：115.64.4.0/22，要每個 Subnet 最多支援 60 hosts</h2>



<p class="wp-block-paragraph">60 hosts 至少：</p>



<p class="wp-block-paragraph">6 host bits。</p>



<p class="wp-block-paragraph">因為：</p>



<p class="wp-block-paragraph"><code>2^6 - 2 = 62</code></p>



<p class="wp-block-paragraph">所以 subnet 是：</p>



<p class="wp-block-paragraph"><code>/26</code></p>



<p class="wp-block-paragraph">原本 <code>/22</code>。</p>



<p class="wp-block-paragraph">借 4 bits 做 subnet：</p>



<p class="wp-block-paragraph"><code>2^4 = 16</code></p>



<p class="wp-block-paragraph">所以最多 16 個這種 subnet。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">IPv4 / IPv6</h1>



<h2 class="wp-block-heading">2014 / 2015：IPv4 有哪些限制，為什麼需要 IPv6？</h2>



<p class="wp-block-paragraph">最基本一定要想到：</p>



<p class="wp-block-paragraph">IPv4 Address Exhaustion。</p>



<p class="wp-block-paragraph">其他可以從：</p>



<p class="wp-block-paragraph">Header design<br>Fragmentation<br>Address configuration<br>Routing scalability<br>Security / newer protocol requirements</p>



<p class="wp-block-paragraph">等方向回答。</p>



<p class="wp-block-paragraph">最重要的還是 IPv6：</p>



<p class="wp-block-paragraph">128-bit address space。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2013：IPv6 tunnel 經過 IPv4 Network 時，為什麼可以把 IPv4 Network 看成 Link Layer？</h2>



<p class="wp-block-paragraph">因為對 tunnel 兩端的 IPv6 routers 來說：</p>



<p class="wp-block-paragraph">整個 IPv6 datagram 被 encapsulate 在 IPv4 datagram 裡。</p>



<p class="wp-block-paragraph">中間 IPv4 routers 根本不需要理解 IPv6 packet。</p>



<p class="wp-block-paragraph">從 IPv6 的角度看：</p>



<p class="wp-block-paragraph">中間整段 IPv4 infrastructure 就像提供了一條 link。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2013：IPv6 為什麼把 Router Fragmentation 拿掉？</h2>



<p class="wp-block-paragraph">IPv6 router 不替 packet fragmentation。</p>



<p class="wp-block-paragraph">如果 packet 太大：</p>



<p class="wp-block-paragraph">由 source 根據 Path MTU 處理。</p>



<p class="wp-block-paragraph"><strong>優點：</strong></p>



<p class="wp-block-paragraph">Router forwarding path 更簡單。</p>



<p class="wp-block-paragraph">不用每台中間 router 花時間 fragmentation。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：IPv6 Address 比 IPv4 長，所以 Router 一定比較慢嗎？</h2>



<p class="wp-block-paragraph">不一定。</p>



<p class="wp-block-paragraph">不能只看：</p>



<p class="wp-block-paragraph">32-bit vs 128-bit。</p>



<p class="wp-block-paragraph">IPv6 header 本身反而有做簡化：</p>



<p class="wp-block-paragraph">Fixed-length base header<br>Router 不做 fragmentation<br>沒有 IPv4-style header checksum recalculation</p>



<p class="wp-block-paragraph">所以 address 長度只是其中一個因素。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">IPv4 Fragmentation</h1>



<h2 class="wp-block-heading">2013：3000-byte Datagram 經過 MTU 700 的 Link，要切多少 Fragment？</h2>



<p class="wp-block-paragraph">這題重點不只是除法。</p>



<p class="wp-block-paragraph">IP header 假設 20 bytes：</p>



<p class="wp-block-paragraph">每個 fragment 最大 payload：</p>



<p class="wp-block-paragraph"><code>700 - 20 = 680 bytes</code></p>



<p class="wp-block-paragraph">而除了最後一個 fragment，payload 通常要符合 8-byte fragment offset 單位。</p>



<p class="wp-block-paragraph">接著追蹤：</p>



<p class="wp-block-paragraph">Identification<br>Fragment Offset<br>More Fragments flag<br>Total Length</p>



<p class="wp-block-paragraph">這種題最好真的自己完整算一次。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：每個 Datagram 最大 1500 bytes，20-byte IP Header，傳 5,000,000 bytes MP3 要幾個 Datagram？</h2>



<p class="wp-block-paragraph">每個 datagram 可以裝的 application data：</p>



<p class="wp-block-paragraph"><code>1500 - 20 = 1480 bytes</code></p>



<p class="wp-block-paragraph">所以：</p>



<p class="wp-block-paragraph"><code>ceil(5,000,000 / 1480)</code></p>



<p class="wp-block-paragraph">最後記得無條件進位。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Forwarding</h1>



<h2 class="wp-block-heading">2015：Source 和 Destination 中間有三台 Routers，Datagram 經過多少 Interfaces？查幾次 Forwarding Table？</h2>



<p class="wp-block-paragraph">畫圖最快：</p>



<p class="wp-block-paragraph">Host<br>→ R1<br>→ R2<br>→ R3<br>→ Host</p>



<p class="wp-block-paragraph">每條 link 都有兩側 interface。</p>



<p class="wp-block-paragraph">Router 每次收到 packet，都必須查 forwarding table 決定 outgoing interface。</p>



<p class="wp-block-paragraph">題目就是在確認：</p>



<p class="wp-block-paragraph">Link<br>Interface<br>Router forwarding</p>



<p class="wp-block-paragraph">三個概念不要混在一起。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：Host B 怎麼知道收到的 IP Payload 要交給 TCP 還是 UDP？</h2>



<p class="wp-block-paragraph">看 IP Header 裡的：</p>



<p class="wp-block-paragraph">Protocol field。</p>



<p class="wp-block-paragraph">例如 IPv4 裡：</p>



<p class="wp-block-paragraph">TCP = Protocol 6<br>UDP = Protocol 17</p>



<p class="wp-block-paragraph">Network Layer 就靠這個值 demultiplex 到上一層 protocol。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">4. Link Layer</h1>



<p class="wp-block-paragraph">這區考得非常廣。</p>



<p class="wp-block-paragraph">主要有：</p>



<p class="wp-block-paragraph">Error Detection<br>ALOHA<br>CSMA/CD<br>ARP<br>MPLS<br>Spanning Tree<br>802.11<br>PPP</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Collision / CSMA/CD</h1>



<h2 class="wp-block-heading">2013：明明傳送前有先 Listen，為什麼還是可能 Collision？</h2>



<p class="wp-block-paragraph">因為：</p>



<p class="wp-block-paragraph">Propagation Delay。</p>



<p class="wp-block-paragraph">A 開始傳資料。</p>



<p class="wp-block-paragraph">但訊號還沒傳到 B。</p>



<p class="wp-block-paragraph">B 此時聽起來仍然是 idle。</p>



<p class="wp-block-paragraph">所以 B 也開始 transmit。</p>



<p class="wp-block-paragraph">兩個 signal 最後就在 link 上 collision。</p>



<p class="wp-block-paragraph">這題是 CSMA 最核心的概念。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：CSMA/CD 怎麼運作？</h2>



<p class="wp-block-paragraph">流程可以記：</p>



<p class="wp-block-paragraph">Sense channel。</p>



<p class="wp-block-paragraph">Idle 才 transmit。</p>



<p class="wp-block-paragraph">Transmit 同時繼續 listen。</p>



<p class="wp-block-paragraph">Detect collision。</p>



<p class="wp-block-paragraph">停止 transmission / send jam signal。</p>



<p class="wp-block-paragraph">Binary exponential backoff。</p>



<p class="wp-block-paragraph">Random wait。</p>



<p class="wp-block-paragraph">重新嘗試。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：Full-Duplex Ethernet 為什麼可以沒有 Collision？</h2>



<p class="wp-block-paragraph">因為 modern switched Ethernet 的 full-duplex link：</p>



<p class="wp-block-paragraph">兩端可以同時使用各自方向的 channel。</p>



<p class="wp-block-paragraph">不再是多人共用同一個 collision domain。</p>



<p class="wp-block-paragraph">因此不需要傳統 half-duplex Ethernet 那種 CSMA/CD collision handling。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：怎麼提高 CSMA/CD Efficiency？</h2>



<p class="wp-block-paragraph">題目給：</p>



<p class="wp-block-paragraph"><code>Efficiency = 1 / (1 + 5tprop/ttrans)</code></p>



<p class="wp-block-paragraph">所以提高 efficiency：</p>



<p class="wp-block-paragraph">降低 <code>tprop</code></p>



<p class="wp-block-paragraph">或提高 <code>ttrans</code>。</p>



<p class="wp-block-paragraph">實務上的意思：</p>



<p class="wp-block-paragraph">縮短 network 最大距離，可以降低 propagation delay。</p>



<p class="wp-block-paragraph">增加 frame size，可以增加 transmission delay。</p>



<p class="wp-block-paragraph">重點是看 ratio：</p>



<p class="wp-block-paragraph"><code>tprop / ttrans</code></p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：Binary Exponential Backoff，已經發生 7 次 Collision，最大等多久？</h2>



<p class="wp-block-paragraph">第 7 次 collision：</p>



<p class="wp-block-paragraph">K 可以從：</p>



<p class="wp-block-paragraph"><code>0 ... 2^7 - 1</code></p>



<p class="wp-block-paragraph">所以最大：</p>



<p class="wp-block-paragraph">127。</p>



<p class="wp-block-paragraph">每一單位是：</p>



<p class="wp-block-paragraph">512 bit times。</p>



<p class="wp-block-paragraph">在 10 Mb/s：</p>



<p class="wp-block-paragraph">先算 512 bits 的 transmission time。</p>



<p class="wp-block-paragraph">再乘 127。</p>



<p class="wp-block-paragraph">這種題最好把：</p>



<p class="wp-block-paragraph">bit time</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">seconds</p>



<p class="wp-block-paragraph">分開算。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">ALOHA / Multiple Access</h1>



<h2 class="wp-block-heading">2014：Slotted ALOHA 最大 Efficiency</h2>



<p class="wp-block-paragraph">經典結果：</p>



<p class="wp-block-paragraph"><code>1/e ≈ 0.368</code></p>



<p class="wp-block-paragraph">約 36.8%。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：為什麼 Pure ALOHA 最大 Efficiency 只有 Slotted ALOHA 一半？</h2>



<p class="wp-block-paragraph">關鍵是：</p>



<p class="wp-block-paragraph">Vulnerable Period。</p>



<p class="wp-block-paragraph">Slotted ALOHA 只能在 slot boundary 開始傳。</p>



<p class="wp-block-paragraph">Pure ALOHA 隨時都可以開始。</p>



<p class="wp-block-paragraph">因此一個 frame 在 Pure ALOHA 裡可能跟：</p>



<p class="wp-block-paragraph">前面一個 frame</p>



<p class="wp-block-paragraph">或</p>



<p class="wp-block-paragraph">後面一個 frame</p>



<p class="wp-block-paragraph">重疊。</p>



<p class="wp-block-paragraph">Vulnerable period 是兩個 frame time。</p>



<p class="wp-block-paragraph">所以最大 efficiency：</p>



<p class="wp-block-paragraph">Pure ALOHA 約 18.4%。</p>



<p class="wp-block-paragraph">Slotted ALOHA 約 36.8%。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：TDMA、FDMA、Slotted ALOHA、Pure ALOHA 怎麼共享 2 Mbps Link？</h2>



<p class="wp-block-paragraph">這題不要急著背數字。</p>



<p class="wp-block-paragraph">先分：</p>



<p class="wp-block-paragraph">Channel Partitioning：</p>



<p class="wp-block-paragraph">TDMA<br>FDMA</p>



<p class="wp-block-paragraph">Random Access：</p>



<p class="wp-block-paragraph">ALOHA</p>



<p class="wp-block-paragraph">再看：</p>



<p class="wp-block-paragraph">有幾個 hosts<br>每個 active 時需要多少 bandwidth<br>每個 host active 的 probability</p>



<p class="wp-block-paragraph">Static partitioning 的問題是：</p>



<p class="wp-block-paragraph">Host 不使用時，分給它的 bandwidth 可能浪費。</p>



<p class="wp-block-paragraph">Random access 可以共享完整 channel，但會有 collision。</p>



<p class="wp-block-paragraph">這就是題目真正想比較的 trade-off。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Error Detection / Correction</h1>



<h2 class="wp-block-heading">2013：Physical Link 有 Error，是不是永遠不可能做成 Error-Free Link？</h2>



<p class="wp-block-paragraph">要分：</p>



<p class="wp-block-paragraph">Physical Layer 實際會不會出 bit error</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">上層提供給使用者的 service 是否可以做到可靠</p>



<p class="wp-block-paragraph">不是同一件事。</p>



<p class="wp-block-paragraph">可以用：</p>



<p class="wp-block-paragraph">Error Detection<br>Error Correction<br>Retransmission</p>



<p class="wp-block-paragraph">把底層有 error 的 channel 包裝成非常可靠的 logical service。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2013：CRC</h2>



<p class="wp-block-paragraph">給 Generator：</p>



<p class="wp-block-paragraph"><code>1001</code></p>



<p class="wp-block-paragraph">再給 received data。</p>



<p class="wp-block-paragraph">要判斷：</p>



<p class="wp-block-paragraph">Burst error detection ability<br>CRC bits<br>Data 是否正確</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">Generator 長度是 4 bits，所以 degree 是 3。</p>



<p class="wp-block-paragraph">CRC remainder 是 3 bits。</p>



<p class="wp-block-paragraph">收到完整 codeword 後：</p>



<p class="wp-block-paragraph">用 Generator 做 modulo-2 division。</p>



<p class="wp-block-paragraph">Remainder = 0：</p>



<p class="wp-block-paragraph">沒有偵測到錯誤。</p>



<p class="wp-block-paragraph">不是 0：</p>



<p class="wp-block-paragraph">偵測到 error。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：Two-Dimensional Even Parity</h2>



<p class="wp-block-paragraph">題目給一串 bit pattern，要算最短 parity field。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">先把 data 排成矩陣。</p>



<p class="wp-block-paragraph">每一 row 加 parity。</p>



<p class="wp-block-paragraph">每一 column 也加 parity。</p>



<p class="wp-block-paragraph">讓：</p>



<p class="wp-block-paragraph">每一 row 的 1 都是偶數。</p>



<p class="wp-block-paragraph">每一 column 的 1 也都是偶數。</p>



<p class="wp-block-paragraph">2D parity 比單一 parity 更強，因為 single-bit error 可以透過：</p>



<p class="wp-block-paragraph">錯誤 row</p>



<p class="wp-block-paragraph">和</p>



<p class="wp-block-paragraph">錯誤 column</p>



<p class="wp-block-paragraph">交叉定位。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">ARP</h1>



<p class="wp-block-paragraph">ARP 在 2013 跟 2015 都出現幾乎一樣的問題。</p>



<h2 class="wp-block-heading">為什麼 ARP Request 是 Broadcast？</h2>



<p class="wp-block-paragraph">因為 sender 已經知道：</p>



<p class="wp-block-paragraph">Target IP。</p>



<p class="wp-block-paragraph">但不知道：</p>



<p class="wp-block-paragraph">Target MAC。</p>



<p class="wp-block-paragraph">所以根本不知道 Ethernet frame 的 destination MAC 應該填誰。</p>



<p class="wp-block-paragraph">只能 broadcast：</p>



<p class="wp-block-paragraph">「誰有這個 IP？」</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">為什麼 ARP Reply 不需要 Broadcast？</h2>



<p class="wp-block-paragraph">收到 Request 的 host 已經從 request frame 知道：</p>



<p class="wp-block-paragraph">Requester 的 MAC。</p>



<p class="wp-block-paragraph">所以可以直接 unicast 回去。</p>



<p class="wp-block-paragraph">沒有必要讓 LAN 所有人都處理一次。</p>



<p class="wp-block-paragraph">這題算是非常值得記的基本題。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Spanning Tree Protocol</h1>



<h2 class="wp-block-heading">2013 / 2014：STP 在做什麼？為什麼 Redundant Layer 2 Links 需要關掉部分 Port？</h2>



<p class="wp-block-paragraph">Ethernet Layer 2 loop 很危險。</p>



<p class="wp-block-paragraph">可能造成：</p>



<p class="wp-block-paragraph">Broadcast Storm</p>



<p class="wp-block-paragraph">Frame 無限循環</p>



<p class="wp-block-paragraph">MAC Table Instability</p>



<p class="wp-block-paragraph">STP 的工作就是：</p>



<p class="wp-block-paragraph">保留實體 redundancy，</p>



<p class="wp-block-paragraph">但建立一個 logical loop-free topology。</p>



<p class="wp-block-paragraph">部分 redundant port 暫時 block。</p>



<p class="wp-block-paragraph">等主要 path 壞掉，再重新 convergence。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">MPLS</h1>



<p class="wp-block-paragraph">2013、2014、2015 都有 MPLS。</p>



<p class="wp-block-paragraph">算是三年連續重點。</p>



<h2 class="wp-block-heading">基本題：Packet 怎麼通過 MPLS Network？</h2>



<p class="wp-block-paragraph">Ingress router：</p>



<p class="wp-block-paragraph">根據 packet 分類，加入 label。</p>



<p class="wp-block-paragraph">中間 Label Switch Router：</p>



<p class="wp-block-paragraph">主要看 label。</p>



<p class="wp-block-paragraph">做：</p>



<p class="wp-block-paragraph">Label Lookup<br>Label Swap<br>Forward</p>



<p class="wp-block-paragraph">而不是每一 hop 都做完整 IP longest-prefix lookup。</p>



<p class="wp-block-paragraph">到了 Egress：</p>



<p class="wp-block-paragraph">移除 MPLS label。</p>



<p class="wp-block-paragraph">再照正常 IP forwarding。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：MPLS Traffic Engineering</h2>



<p class="wp-block-paragraph">同樣 destination A：</p>



<p class="wp-block-paragraph">來自 R5 的 traffic 走一條 route。</p>



<p class="wp-block-paragraph">來自 R6 的 traffic 走另一條 route。</p>



<p class="wp-block-paragraph">這就是 MPLS 很重要的用途之一：</p>



<p class="wp-block-paragraph">Traffic Engineering。</p>



<p class="wp-block-paragraph">不一定只能按照傳統 IP shortest path。</p>



<p class="wp-block-paragraph">可以透過不同 labels 建立不同 Label Switched Paths。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">PPP</h1>



<h2 class="wp-block-heading">2014：PPP Address Field 有什麼用途？</h2>



<p class="wp-block-paragraph">PPP 是：</p>



<p class="wp-block-paragraph">Point-to-Point。</p>



<p class="wp-block-paragraph">一條 link 就兩端。</p>



<p class="wp-block-paragraph">所以不像 Ethernet LAN 一樣需要靠 MAC address 判斷：</p>



<p class="wp-block-paragraph">這個 frame 是給哪一台 host。</p>



<p class="wp-block-paragraph">因此 PPP address field 並沒有一般 shared LAN address 那麼重要，傳統 PPP address 通常是固定值。</p>



<p class="wp-block-paragraph">重點是理解：</p>



<p class="wp-block-paragraph"><strong>Point-to-Point 根本沒有「到底是 LAN 上哪一台」的問題。</strong></p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">802.11</h1>



<h2 class="wp-block-heading">2013：為什麼 Wi-Fi 收到 Frame 後需要 ACK？</h2>



<p class="wp-block-paragraph">Wireless link 比 wired Ethernet 更容易受到：</p>



<p class="wp-block-paragraph">Interference<br>Noise<br>Fading</p>



<p class="wp-block-paragraph">而且 wireless station 很難像 Ethernet 一樣一邊 transmit 一邊可靠 detect collision。</p>



<p class="wp-block-paragraph">所以 802.11 使用 ACK：</p>



<p class="wp-block-paragraph">Sender 沒收到 ACK，就知道 frame 可能沒有成功送達，需要 retransmit。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Token Ring</h1>



<h2 class="wp-block-heading">2013：LAN perimeter 很大時，為什麼 Token Ring 會沒效率？</h2>



<p class="wp-block-paragraph">因為 perimeter 越大：</p>



<p class="wp-block-paragraph">Propagation Delay 越大。</p>



<p class="wp-block-paragraph">Token 本身繞一圈需要更長時間。</p>



<p class="wp-block-paragraph">如果 frame transmission time <code>L/R</code> 相對很短，但 token propagation 很長，大量時間都花在等 token 移動。</p>



<p class="wp-block-paragraph">所以效率下降。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">5. ICMP / SNMP / Security</h1>



<p class="wp-block-paragraph">這區題數比較少，但出題模式其實滿固定。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">ICMP</h1>



<h2 class="wp-block-heading">2015：Ping 可以怎麼 Debug Network？</h2>



<p class="wp-block-paragraph">一個很好用的方式是逐步測。</p>



<p class="wp-block-paragraph">先：</p>



<p class="wp-block-paragraph">Ping localhost / local interface。</p>



<p class="wp-block-paragraph">再：</p>



<p class="wp-block-paragraph">Ping default gateway。</p>



<p class="wp-block-paragraph">再：</p>



<p class="wp-block-paragraph">Ping 同 network 其他 host。</p>



<p class="wp-block-paragraph">最後：</p>



<p class="wp-block-paragraph">Ping Internet remote host。</p>



<p class="wp-block-paragraph">如果：</p>



<p class="wp-block-paragraph">Gateway ping 得到，但 Internet ping 不到，</p>



<p class="wp-block-paragraph">問題就比較可能在：</p>



<p class="wp-block-paragraph">Router / ISP / upstream。</p>



<p class="wp-block-paragraph">這比直接說「Ping 看通不通」完整很多。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：Traceroute 怎麼知道中間經過哪些 Routers？</h2>



<p class="wp-block-paragraph">核心是：</p>



<p class="wp-block-paragraph">TTL。</p>



<p class="wp-block-paragraph">先送：</p>



<p class="wp-block-paragraph">TTL = 1。</p>



<p class="wp-block-paragraph">第一台 router 收到後：</p>



<p class="wp-block-paragraph">TTL → 0。</p>



<p class="wp-block-paragraph">丟掉 packet。</p>



<p class="wp-block-paragraph">回：</p>



<p class="wp-block-paragraph">ICMP Time Exceeded。</p>



<p class="wp-block-paragraph">因此知道第一台 router。</p>



<p class="wp-block-paragraph">再送：</p>



<p class="wp-block-paragraph">TTL = 2。</p>



<p class="wp-block-paragraph">得到第二台 router。</p>



<p class="wp-block-paragraph">然後：</p>



<p class="wp-block-paragraph">3、4、5……</p>



<p class="wp-block-paragraph">一路增加。</p>



<p class="wp-block-paragraph">就可以慢慢建立完整 path。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">SNMP</h1>



<h2 class="wp-block-heading">2013：Request-Response 跟 Trap 差在哪？</h2>



<p class="wp-block-paragraph">Request-Response：</p>



<p class="wp-block-paragraph">Manager 主動 poll agent。</p>



<p class="wp-block-paragraph">Trap：</p>



<p class="wp-block-paragraph">Agent 發現事件後主動通知 manager。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2014：要監控 Network Interface Up / Down，適合 Polling 還是 Trap？</h2>



<p class="wp-block-paragraph">通常：</p>



<p class="wp-block-paragraph">Trap。</p>



<p class="wp-block-paragraph">因為：</p>



<p class="wp-block-paragraph">Link down 是事件。</p>



<p class="wp-block-paragraph">如果一直 polling：</p>



<p class="wp-block-paragraph">大部分 query 都只是得到「現在正常」。</p>



<p class="wp-block-paragraph">很浪費。</p>



<p class="wp-block-paragraph">Trap 可以 event 發生時馬上送。</p>



<p class="wp-block-paragraph">Trade-off 是：</p>



<p class="wp-block-paragraph">Trap message 如果 lost，可能沒有第二次機會。</p>



<p class="wp-block-paragraph">Polling 雖然 overhead 高，但可以持續重新確認狀態。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Hash / Integrity</h1>



<h2 class="wp-block-heading">2014：只改 Message 一小部分，MD5 Digest 會怎樣？</h2>



<p class="wp-block-paragraph">Cryptographic hash 的特性之一：</p>



<p class="wp-block-paragraph">輸入只改很小一部分，</p>



<p class="wp-block-paragraph">output 也會產生完全不同、難以預測的 digest。</p>



<p class="wp-block-paragraph">不要以為：</p>



<p class="wp-block-paragraph">2012 改成 2013</p>



<p class="wp-block-paragraph">hash 只會改幾個字元。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h2 class="wp-block-heading">2015：Hash 為什麼比 Internet Checksum 更適合 Message Integrity / Security？</h2>



<p class="wp-block-paragraph">Checksum 主要設計來偵測：</p>



<p class="wp-block-paragraph">意外 transmission error。</p>



<p class="wp-block-paragraph">不是拿來對抗 attacker。</p>



<p class="wp-block-paragraph">Cryptographic hash 的設計則希望做到：</p>



<p class="wp-block-paragraph">很難找到兩個不同 messages 有相同 digest。</p>



<p class="wp-block-paragraph">很難根據 digest 反推出原文。</p>



<p class="wp-block-paragraph">所以如果是 security / malicious modification：</p>



<p class="wp-block-paragraph">Hash 才是正確方向。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Digital Signature</h1>



<h2 class="wp-block-heading">2013：為什麼 Digital Signature 通常 Sign Hash，而不是直接用 Private Key 處理整份 Message？</h2>



<p class="wp-block-paragraph">主要是效率。</p>



<p class="wp-block-paragraph">Message 可能非常大。</p>



<p class="wp-block-paragraph">Hash 可以先把任意長度資料轉成固定長度 digest。</p>



<p class="wp-block-paragraph">接著只要：</p>



<p class="wp-block-paragraph">Sign Digest。</p>



<p class="wp-block-paragraph">同時這個 digest 又代表整份 message 的內容。</p>



<p class="wp-block-paragraph">因此：</p>



<p class="wp-block-paragraph">效率高很多。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Public Key / Man-in-the-Middle</h1>



<h2 class="wp-block-heading">2013：只有 Public Key Cryptography，可以避免 Man-in-the-Middle 嗎？</h2>



<p class="wp-block-paragraph">不行。</p>



<p class="wp-block-paragraph">最大的問題不是：</p>



<p class="wp-block-paragraph">「Public Key 安不安全？」</p>



<p class="wp-block-paragraph">而是：</p>



<p class="wp-block-paragraph"><strong>「你怎麼知道這把 Public Key 真的是對方的？」</strong></p>



<p class="wp-block-paragraph">Attacker 可以攔截：</p>



<p class="wp-block-paragraph">Alice → Bob</p>



<p class="wp-block-paragraph">然後分別給兩邊自己的 key。</p>



<p class="wp-block-paragraph">Alice 以為自己拿到 Bob 的 key。</p>



<p class="wp-block-paragraph">Bob 以為自己拿到 Alice 的 key。</p>



<p class="wp-block-paragraph">所以還需要：</p>



<p class="wp-block-paragraph">Certificate<br>Certificate Authority<br>Authenticated key distribution</p>



<p class="wp-block-paragraph">把：</p>



<p class="wp-block-paragraph">Identity</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">Public Key</p>



<p class="wp-block-paragraph">綁在一起。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Nonce</h1>



<h2 class="wp-block-heading">2013：Challenge-Response Authentication 為什麼要 Nonce？</h2>



<p class="wp-block-paragraph">Nonce：</p>



<p class="wp-block-paragraph">Number used once。</p>



<p class="wp-block-paragraph">重點是：</p>



<p class="wp-block-paragraph">Freshness。</p>



<p class="wp-block-paragraph">Server 每次 authentication 都產生新的 challenge。</p>



<p class="wp-block-paragraph">所以 attacker 就算以前錄下合法 response：</p>



<p class="wp-block-paragraph">下次 challenge 已經不同。</p>



<p class="wp-block-paragraph">舊 response 不能直接 replay。</p>



<p class="wp-block-paragraph">主要防：</p>



<p class="wp-block-paragraph">Replay Attack。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Digital Certificate</h1>



<h2 class="wp-block-heading">2015：</h2>



<p class="wp-block-paragraph">「CA 建立 Certificate 後，整張 Certificate 通常會用 CA 的 Public Key Encrypt。」</p>



<p class="wp-block-paragraph">True or False？</p>



<p class="wp-block-paragraph">False。</p>



<p class="wp-block-paragraph"><strong>解題思路：</strong></p>



<p class="wp-block-paragraph">CA 是：</p>



<p class="wp-block-paragraph">用自己的 Private Key 做 Digital Signature。</p>



<p class="wp-block-paragraph">Client 則：</p>



<p class="wp-block-paragraph">使用 CA Public Key 驗證 Signature。</p>



<p class="wp-block-paragraph">Certificate 本身不需要整份用 CA Public Key 加密。</p>



<p class="wp-block-paragraph">這裡最容易混：</p>



<p class="wp-block-paragraph">Encryption</p>



<p class="wp-block-paragraph">跟</p>



<p class="wp-block-paragraph">Signature。</p>



<p class="wp-block-paragraph">Public Key / Private Key 到底誰用哪一把，也一定要搞清楚。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">Secure Email</h1>



<h2 class="wp-block-heading">2014：怎麼透過 SMTP 提供 Secure Email？</h2>



<p class="wp-block-paragraph">這是一題把整個 Security chapter 串在一起的題目。</p>



<p class="wp-block-paragraph">至少要想到三個目標：</p>



<p class="wp-block-paragraph">Confidentiality<br>Integrity<br>Authentication</p>



<p class="wp-block-paragraph">一個典型做法：</p>



<p class="wp-block-paragraph">先產生 symmetric session key。</p>



<p class="wp-block-paragraph">用 symmetric key encrypt email content。</p>



<p class="wp-block-paragraph">因為 symmetric encryption 處理大量資料比較快。</p>



<p class="wp-block-paragraph">再用 receiver 的 public key：</p>



<p class="wp-block-paragraph">encrypt session key。</p>



<p class="wp-block-paragraph">這樣只有 receiver 的 private key 可以取得 session key。</p>



<p class="wp-block-paragraph">接著：</p>



<p class="wp-block-paragraph">對 message 做 hash。</p>



<p class="wp-block-paragraph">Sender 使用自己的 private key sign hash。</p>



<p class="wp-block-paragraph">Receiver 使用 sender public key verify signature。</p>



<p class="wp-block-paragraph">因此同時可以提供：</p>



<p class="wp-block-paragraph">Confidentiality</p>



<p class="wp-block-paragraph">Message Integrity</p>



<p class="wp-block-paragraph">Sender Authentication。</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">哪些是高頻題？</h1>



<p class="wp-block-paragraph">Application Layer 幾乎一直圍繞：</p>



<p class="wp-block-paragraph">Delay<br>P2P vs Client/Server<br>DNS<br>HTTP</p>



<p class="wp-block-paragraph">Transport Layer：</p>



<p class="wp-block-paragraph">Reliable Transport<br>GBN / SR<br>Congestion Control<br>Flow Control<br>TCP Connection</p>



<p class="wp-block-paragraph">Network Layer：</p>



<p class="wp-block-paragraph">Dijkstra<br>Distance Vector<br>Subnetting<br>IPv4 / IPv6</p>



<p class="wp-block-paragraph">Link Layer：</p>



<p class="wp-block-paragraph">Error Detection<br>Multiple Access<br>CSMA/CD<br>ARP<br>MPLS<br>STP</p>



<p class="wp-block-paragraph">Security：</p>



<p class="wp-block-paragraph">Hash<br>Digital Signature<br>Authentication<br>ICMP / SNMP</p>



<hr class="wp-block-separator has-alpha-channel-opacity" />



<h1 class="wp-block-heading">直接練習的題庫</h1>



<p class="wp-block-paragraph">當時讀 CNA 時，手上的資料很多都是：</p>



<p class="wp-block-paragraph">PDF<br>Paper Exam<br>Lecture Slides<br>自己整理的 Word<br>零散答案</p>



<p class="wp-block-paragraph">單份看都沒有問題，但沒有一個地方把它們整理成：Topic → Question → Hint → Answer</p>



<p class="wp-block-paragraph">這種可以直接練習的形式，把目前整理好的題目做成一個簡單的 Web App，可以：</p>



<p class="wp-block-paragraph">依 Layer 找題目。</p>



<p class="wp-block-paragraph">依 DNS、HTTP、TCP、Routing、ARP 等 Topic 找題目。</p>



<p class="wp-block-paragraph">先只看 Question。</p>



<p class="wp-block-paragraph">需要時再打開 Hint / 解題思路。</p>



<p class="wp-block-paragraph">最後才看 Answer。</p>



<p class="wp-block-paragraph">不是一個很複雜的產品，只是希望之後在 Adelaide University 修 CNA，或單純想複習的人，不用再從一堆 PDF 裡面自己慢慢找題目。</p>



<p class="wp-block-paragraph"><strong>Web App：</strong><a href="https://leo0331.github.io/cna-practice/">CNA Practice — Computer Networks Past Questions</a></p>



<p class="wp-block-paragraph">之後如果有時間，再把其他年份跟當時留下來的分類筆記慢慢補進去，這篇整理的是當年留下來的考古題與複習資料，主要用途是協助理解概念跟練習題型，不代表現在課程的 syllabus或考試範圍完全一樣。</p>
{% endraw %}
