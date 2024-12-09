<script lang="ts">
    import * as config from '$lib/config'
    import xIconLight from "/src/assets/svg/x-icon-light.svg"
    import xIconDark from "/src/assets/svg/x-icon-dark.svg"
    import githubIconLight from "/src/assets/svg/github-icon-light.svg"
    import githubIconDark from "/src/assets/svg/github-icon-dark.svg"
    import { CornerDownRightIcon } from 'lucide-svelte'
    import { onMount } from 'svelte'

    let isDarkMode = false;

    onMount(() => {
        // Check if the user prefers dark mode
        const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        
        // Set initial dark mode state
        isDarkMode = darkModeMediaQuery.matches;

        // Listen for changes in color scheme
        const handleColorSchemeChange = (e: MediaQueryListEvent) => {
            isDarkMode = e.matches;
        };

        darkModeMediaQuery.addEventListener('change', handleColorSchemeChange);

        // Cleanup listener when component is destroyed
        return () => {
            darkModeMediaQuery.removeEventListener('change', handleColorSchemeChange);
        };
    });
</script>

<footer>
    <div class="footer-content">
        <p>&copy; <a href="https://poeticterrorism.net">{config.title}</a></p>
        <div class="social-links">
            <a href="https://x.com/jplwvp" target="_blank" rel="noopener noreferrer">
                <img 
                    src={isDarkMode ? xIconLight : xIconDark} 
                    alt="X (Twitter)" 
                />
            </a>
            <a href="https://github.com/Poetic-Terrorism" target="_blank" rel="noopener noreferrer">
                <img 
                    src={isDarkMode ? githubIconLight : githubIconDark} 
                    alt="GitHub" 
                />
            </a>
        </div>
    </div>
</footer>

<style>
    footer {
        padding-block: var(--size-7);
        border-top: 1px solid var(--border);
        
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
    }

    .footer-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: var(--size-4);
    }

    p {
        color: var(--text-2);
        text-align: center;
    }

    a {
        color: inherit;
        text-decoration: none;
    }

    .social-links {
        display: flex;
        gap: var(--size-4);
        align-items: center;
    }

    .social-links img {
        width: 24px;
        height: 24px;
        opacity: 0.7;
        transition: opacity 0.3s ease;
    }

    .social-links img:hover {
        opacity: 1;
    }

    /* Responsive considerations */
    @media (max-width: 768px) {
        footer {
            padding-block: var(--size-7);
        }
    }
</style>