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
<button>Toggle</button>

</nav>

<style>
    nav{
padding-block: var(--size-7);
    }
    .links{
        margin-block: var(--size-7);
        display: flex;
    gap: 2rem;
    margin-block: 0;
    align-items: center;
}
    
a{

    color: inherit;
    text-decoration: none;
}
@media (min-width: 768px){
nav{
display: flex;
justify-content: space-between;

}
.links{
    display: flex;
    gap: 2rem;
    margin-block: 0;
}

}

</style>