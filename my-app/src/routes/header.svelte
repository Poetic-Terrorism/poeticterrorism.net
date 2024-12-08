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
     </ul>
    
    </nav>
    
    <style>
        nav {
            padding-block: var(--size-7);
            display: flex;
            justify-content: center; /* Center-align the navigation */
        }
        
        .links {
            display: flex;
            gap: 2rem;
            margin-block: 0;
            align-items: center;
            justify-content: center; /* Ensure links are centered */
        }
        
        a {
            color: inherit;
            text-decoration: none;
        }
    
        @media (min-width: 768px) {
            nav {
                justify-content: center; /* Maintain center alignment on larger screens */
            }
            
            .links {
                justify-content: center; /* Ensure links remain centered */
            }
        }
    </style>