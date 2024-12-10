<script lang="ts">
    import { onMount } from 'svelte';
    import xIconLight from "/src/assets/svg/x-icon-light.svg";
    import xIconDark from "/src/assets/svg/x-icon-dark.svg";
    import githubIconLight from "/src/assets/svg/github-icon-light.svg";
    import githubIconDark from "/src/assets/svg/github-icon-dark.svg";
    import icon from "/src/assets/svg/white.svg";

    let isDarkMode = false;

    const profile = {
        name: "文化",
        title: "the moralist (2002-)",
        bio: "Whatever.",
        skills: [
            "Applied mathematics",
            "Game development (Godot)", 
            "Web development (Svelte)",
            ],
        socialLinks: [
            { 
                platform: "X", 
                url: "https://x.com/jplwvp",
                iconLight: xIconLight,
                iconDark: xIconDark
            },
            { 
                platform: "GitHub", 
                url: "https://github.com/Poetic-Terrorism",
                iconLight: githubIconLight,
                iconDark: githubIconDark
            }
        ],
        interests: [
            {
                category: "Movies",
                items: [
                    "Interstellar(2014)", 
                    "The Wolf of Wall Street(2013)", 
                    "Pulp Fiction(1994)",

                ]
            },
            
            {
                category: "Books",
                items: [
                    "Norwegian Wood(1987)",

                ]
            },
            {
                category: "Music",
                items: [
                    "Music(2013, sakanaction)",

                ]
            },
            {
                category: "Games",
                items: [
                    "The Beginner's Guide(2015)"
                   
                ]
            },
            {
                category: "Theories",
                items: [
                   "Theorema Egregium",
                ]
            },
            {
                category: "Inequalities",
                items: [
                    "r > g"
                ]
            },

        ]
    };

    onMount(() => {
        const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        isDarkMode = darkModeMediaQuery.matches;

        const handleColorSchemeChange = (e: MediaQueryListEvent) => {
            isDarkMode = e.matches;
        };

        darkModeMediaQuery.addEventListener('change', handleColorSchemeChange);

        return () => {
            darkModeMediaQuery.removeEventListener('change', handleColorSchemeChange);
        };
    });

    let isVisible = false;

    onMount(() => {
        setTimeout(() => {
            isVisible = true;
        }, 50);
    });
</script>

<div class="profile-container" class:visible={isVisible}>
    <div class="profile-wrapper">
        <div class="profile-header">
            <div class="profile-image-container">
                <img src={icon} alt={profile.name} class="profile-image" />
            </div>
            <div class="profile-intro">
                <h1 class="profile-name">{profile.name}</h1>
                <h2 class="profile-title">{profile.title}</h2>
                <div class="social-links">
                    {#each profile.socialLinks as social}
                        <a href={social.url} target="_blank" rel="noopener noreferrer" class="social-icon">
                            <img 
                                src={isDarkMode ? social.iconLight : social.iconDark} 
                                alt={social.platform} 
                            />
                        </a>
                    {/each}
                </div>
            </div>
        </div>

        <div class="profile-content">
            <section class="bio">
                <h3>About Me</h3>
                <div class="bio-content">
                    <p>{profile.bio}</p>
                </div>
            </section>

            <div class="profile-grid">
                <section class="skills">
                    <h3>Skills</h3>
                    <ul>
                        {#each profile.skills as skill}
                            <li>{skill}</li>
                        {/each}
                    </ul>
                </section>

                <section class="interests">
                    {#each profile.interests as interest}
                        <div class="interest-category">
                            <h3>{interest.category}</h3>
                            <ul>
                                {#each interest.items as item}
                                <li>{@html item}</li>
                                {/each}
                            </ul>
                        </div>
                    {/each}
                </section>
            </div>
        </div>
    </div>
</div>

<style>
    :root {
        --background-primary: #ffffff;
        --text-color: #000;
        --background-soft: #f4f4f4;
        --accent-color-light: #e0e4fc;
        --text-secondary: #666;
    }

    /* Dark mode */
    @media (prefers-color-scheme: dark) {
        :root {
            --background-primary: #0F0F0F;
            --text-color: #f0f0f0;
            --background-soft: #1A1A1A;
            --accent-color-light: #4d4d4d;
            --text-secondary: #a7a7a7;

        }
    }

    /* Global Styling */
    .profile-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
        background-color: var(--background-primary);
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        opacity: 0;
        transform: translateY(20px);
        transition: opacity 0.5s ease, transform 0.5s ease;
    }

    .profile-container.visible {
        opacity: 1;
        transform: translateY(0);
    }

    /* Header Styling */
    .profile-header {
        display: flex;
        align-items: center;
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .profile-image-container {
        flex-shrink: 0;
    }

    .profile-image {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid var(--accent-color, #8884d8);
    }

    .profile-intro {
        flex-grow: 1;
    }

    .profile-name {
        font-size: 2.5rem;
        color: var();
        margin-bottom: 0.5rem;
    }

    .profile-title {
        font-size: 1.2rem;
        color: var(--text-secondary);
        margin-bottom: 1rem;
    }

    /* Social Links */
    .social-links {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .social-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 24px;
        height: 24px;
        opacity: 0.7;
        transition: all 0.3s ease;
    }

    .social-icon:hover {
        opacity: 1;
        transform: scale(1.1);
    }

    /* Content Grid */
    .profile-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .skills ul, .interests ul {
        list-style-type: none;
        padding: 0;
    }

    .skills li, .interests li {
        background-color: var(--background-soft);
        margin-bottom: 0.5rem;
        padding: 0.5rem;
        border-radius: 4px;
        transition: background-color 0.3s ease;
    }

    .skills li:hover, .interests li:hover {
        background-color: var(--accent-color-light);
    }
   .bio h3 {
        text-align: center;
        color: var(--text-primary);
        margin-bottom: 1rem;
        position: relative;
        display: inline-block;
        width: 100%;
    }

    .bio h3::after {
        content: '';
        position: absolute;
        bottom: -0.5rem;
        left: 50%;
        transform: translateX(-50%);
        width: 50px;
        height: 2px;
        background-color: var(--text-secondary);
    }

    .bio-content {
        background-color: var(--background-soft);
        border-radius: 8px;
        padding: 1rem;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
    }

    .bio-content p {
        font-style: italic;
        color: var(--text-color);
        max-width: 600px;
        margin: 0;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .profile-header {
            flex-direction: column;
            text-align: center;
        }

        .profile-grid {
            grid-template-columns: 1fr;
        }
    }
</style>