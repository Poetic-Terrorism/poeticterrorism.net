<script lang="ts">
    import * as config from '$lib/config'
        import { CornerDownRightIcon } from 'lucide-svelte'
    </script>

    <footer>
<p>&copy<a href="https://x.com/jplwvp">{config.title}</a></p>
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