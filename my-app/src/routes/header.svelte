<script lang="ts">
    import * as config from '$lib/config'
    import { CornerDownRightIcon } from 'lucide-svelte'
    </script>
    
    <nav>
        <ul class="links">
            <li><a href="/" class="title">Home</a></li>
            <li><a href="/about">About</a></li>
            <li><a href="/blog">Blog</a></li>
            <li><a href="/games">Games</a></li>
            <li><a href="/planets">Planets</a></li>
            <li><a href="/Pendulams">Pendulams</a></li>
            <li><a href="/games/simple-clicker">Clicker</a></li>
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
            padding: 0;
            flex-wrap: wrap; /* Allow items to wrap on smaller screens */
        }
    
        a {
            color: inherit;
            text-decoration: none;
            font-size: 16px; /* デフォルトのフォントサイズ */
        }
    
        /* モバイル向けのスタイル */
        @media (max-width: 767px) {
            .links {
                gap: 1rem; /* スマホでは間隔を狭める */
                padding: 0 1rem; /* 左右に余白を追加 */
            }
    
            a {
                font-size: 14px; /* スマホではフォントサイズを小さく */
            }
        }
    
        /* タブレット・デスクトップ向けのスタイル */
        @media (min-width: 768px) {
            nav {
                justify-content: center;
            }
    
            .links {
                justify-content: center;
            }
        }
    </style>