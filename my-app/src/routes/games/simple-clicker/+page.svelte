<script lang="ts">
    // 必要に応じてメタデータなどを設定
</script>

<svelte:head>
    <title>Simple Clicker | Poetic Terrorism</title>
</svelte:head>

<div class="game-container">
    <iframe 
        src="/games/simple-clicker/index.html" 
        title="Simple Clicker"
        allow="autoplay; fullscreen; clipboard-write"
    ></iframe>
</div>

<style>
    .game-container {
        width: 100%;
        height: 80vh; /* 画面の高さに合わせて調整 */
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 2rem;
    }

    iframe {
        width: 100%;
        height: 100%;
        border: none;
        max-width: 1280px; /* ゲームの最大幅 */
        background-color: #000; /* ロード中の背景色 */
        border-radius: 8px;
    }
</style>