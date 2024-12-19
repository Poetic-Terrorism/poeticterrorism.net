<script lang="ts">
    import * as config from '$lib/config'
    import { CornerDownRightIcon } from 'lucide-svelte'
    </script>
    
    <nav>
    <ul class="links">
    <li>
    <a href="/" class="title">Home</a>
    </li>
    <li>
    <a href="/about">About</a>
    </li>
    
    <li>
        <a href="/blog">Blog</a>
        </li>
    
    <li>
        <a href="/games">Games</a>
    </li>
    <li>
        <a href="/planets">Planets</a>
    </li>
     </ul>
    
    </nav>
    
    <style>
       nav {
    padding-block: var(--size-7);
    display: flex;
    justify-content: center;
}

.links {
    display: flex;
    gap: 2rem;
    margin-block: 0;
    align-items: center;
    justify-content: center;
    max-width: 600px; /* 希望する幅に調整できます */
    width: 100%;      /* コンテナの幅に合わせます */
    padding: 0 1rem;  /* 左右に少しスペースを追加 */
}

a {
    color: inherit;
    text-decoration: none;
}

@media (min-width: 768px) {
    nav {
        justify-content: center;
    }
    
    .links {
        justify-content: center;
    }
}
    </style>