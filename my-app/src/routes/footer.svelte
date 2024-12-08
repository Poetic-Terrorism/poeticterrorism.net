<script lang="ts">
    import * as config from '$lib/config'
        import { CornerDownRightIcon } from 'lucide-svelte'
    </script>

    <footer>
<p><a href="https://x.com/jplwvp">{config.title}</a>&copy {new Date().getFullYear()} </p>
    </footer>

    <style>
        footer{
            padding-block: var(--size-7);
            border-top: 1px solid var(--border);

        }

        p{

            color: var(--text-2)
        }


    </style>