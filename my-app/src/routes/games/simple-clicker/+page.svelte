<script lang="ts">
    // 必要に応じて
</script>

<svelte:head>
    <title>Simple Clicker</title>
</svelte:head>

<div class="game-container">
    <iframe 
        title="Simple Clicker Game"
        frameborder="0" 
        src="https://itch.io/embed-upload/15796217?color=2f4344" 
        allowfullscreen
        allow="autoplay; fullscreen *; geolocation; microphone; camera; midi; monetization; xr-spatial-tracking; gamepad; gyroscope; accelerometer; xr; cross-origin-isolated"
        width="1152" 
        height="668"
    >
        <a href="https://poeticterrorism.itch.io/simple-clicker">Play simple clicker on itch.io</a>
    </iframe>
</div>

<style>
    
    .game-container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        min-height: 100vh;
        padding: 20px;
        background-color: #000;
    }

    iframe {
        max-width: 100%;
        height: auto;
        aspect-ratio: 1152 / 668;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
    }
</style>