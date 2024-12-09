<script lang="ts">
    import { onMount } from 'svelte';
    import xIconLight from "/src/assets/svg/x-icon-light.svg";
    import xIconDark from "/src/assets/svg/x-icon-dark.svg";
    import githubIconLight from "/src/assets/svg/github-icon-light.svg";
    import githubIconDark from "/src/assets/svg/github-icon-dark.svg";
    import icon from "/src/assets/svg/white.svg";
    

    let isDarkMode = false;

    // Cramer-Rao inequality visualization data
    const normalDistributionData = Array.from({length: 50}, (_, i) => {
        const x = (i - 25) / 5;
        return {
            name: x.toFixed(1),
            probability: Math.exp(-0.5 * x * x) / Math.sqrt(2 * Math.PI)
        };
    });

    const profile = {
        name: "文化",
        title: "the moralist",
        bio: "隣人愛",
        skills: [
            "Applied mathematics",
            "Game development", 
            "Web development",
        ],
        socialLinks: [
            { 
                platform: "GitHub", 
                url: "https://github.com/Poetic-Terrorism",
                iconLight: githubIconLight,
                iconDark: githubIconDark
            },
            { 
                platform: "X", 
                url: "https://x.com/jplwvp",
                iconLight: xIconLight,
                iconDark: xIconDark
            }
        ],
        interests: [
            {
                category: "Movies",
                items: [
                    "インターステラー",
                ]
            },
            {
                category: "Books",
                items: [
                    "ノルウェイの森",
                ]
            },
            {
                category: "Games",
                items: [
                    "The Beginner's Guide",
                ]
            },
            {
                category: "Theories",
                items: [
                    "留数定理"
                ]
            },
            {
                category: "Inequality",
                items: [
                    "クラメル・ラオの不等式"
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
                <p>{profile.bio}</p>
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
            <section class="theorem">
                <h3>クラメル・ラオの不等式</h3>
            </section>
  
        </div>
    </div>
</div>

<style>
    /* Global Styling */
    .profile-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 2rem;
        background-color: var(--background-primary, #ffffff);
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
        color: var(--text-primary, #333);
        margin-bottom: 0.5rem;
    }

    .profile-title {
        font-size: 1.2rem;
        color: var(--text-secondary, #666);
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
        background-color: var(--background-soft, #f4f4f4);
        margin-bottom: 0.5rem;
        padding: 0.5rem;
        border-radius: 4px;
        transition: background-color 0.3s ease;
    }

    .skills li:hover, .interests li:hover {
        background-color: var(--accent-color-light, #e0e4fc);
    }

    /* Theorem Section */
    .theorem {
        background-color: var(--background-soft, #f4f4f4);
        padding: 1.5rem;
        border-radius: 8px;
    }

    .chart-container {
        width: 100%;
        height: 300px;
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