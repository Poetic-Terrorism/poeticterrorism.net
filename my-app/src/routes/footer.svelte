<script lang="ts">
    import * as config from '$lib/config'
    import { CornerDownRightIcon } from 'lucide-svelte'
</script>

<footer>
    <p>&copy; <a href="https://x.com/jplwvp">{config.title}</a></p>
</footer>

<style>
    footer {
        padding-block: var(--size-7);
        border-top: 1px solid var(--border);
        
        /* Center-align content */
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
    }

    p {
        color: var(--text-2);
        /* Ensure text is centered */
        text-align: center;
    }

    a {
        /* Optional: add some styling to the link */
        color: inherit;
        text-decoration: none;
        font-weight: bold;
    }

    /* Responsive considerations */
    @media (max-width: 768px) {
        footer {
            padding-block: var(--size-5);
        }
    }
</style>