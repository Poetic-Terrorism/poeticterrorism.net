<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    
    // Configuration
    const totalBalls = 5000;
    const levels = 11;  // Increased number of levels
    const boardWidth = 600;
    const boardHeight = 600;  // Increased height to accommodate more levels
    const ballRadius = 3;
    const pegRadius = 3;
    const pegSpacing = 40;
    
    // Physics parameters
    const gravity = 0.3;
    const bounceVelocity = 1.8;
    
    let balls: Ball[] = [];
    let distribution = Array(13).fill(0);  // Increased bins to match max pegs
    let isAnimating = false;
    let animationFrameId: number | null = null;
    
    class Ball {
        x: number;
        y: number;
        vx: number;
        vy: number;
        finished: boolean;
        bin: number;
        
        constructor() {
            this.x = boardWidth / 2;
            this.y = 10;
            this.vx = 0;
            this.vy = 0;
            this.finished = false;
            this.bin = -1;
        }
        
        move() {
            if (this.finished) return;
            
            // Apply gravity
            this.vy += gravity;
            
            // Apply velocity
            this.x += this.vx;
            this.y += this.vy;
            
            // Damping
            this.vx *= 0.99;
            
            // Check collision with top peg
            const topPegX = boardWidth / 2;
            const topPegY = 80;
            const dx = this.x - topPegX;
            const dy = this.y - topPegY;
            const distance = Math.sqrt(dx * dx + dy * dy);
            
            if (distance < ballRadius + pegRadius + 2) {
                const angle = Math.atan2(dy, dx);
                const bounceAngle = angle + (Math.random() * 0.5 - 0.25);
                
                this.vx = Math.cos(bounceAngle) * bounceVelocity;
                this.vy = Math.abs(Math.sin(bounceAngle) * bounceVelocity);
                
                this.x = topPegX + (ballRadius + pegRadius + 2) * Math.cos(angle);
                this.y = topPegY + (ballRadius + pegRadius + 2) * Math.sin(angle);
            }
            
            // Check collision with other pegs
            const currentLevel = Math.floor((this.y - 80) / pegSpacing);
            if (currentLevel >= 0 && currentLevel < levels) {
                const pegsInRow = 1 + currentLevel;  // Start with 1 peg, increase by 1 each level
                const rowWidth = (pegsInRow - 1) * pegSpacing;
                const startX = (boardWidth - rowWidth) / 2;
                
                for (let i = 0; i < pegsInRow; i++) {
                    const pegX = startX + i * pegSpacing;
                    const pegY = 80 + currentLevel * pegSpacing;
                    
                    const dx = this.x - pegX;
                    const dy = this.y - pegY;
                    const distance = Math.sqrt(dx * dx + dy * dy);
                    
                    if (distance < ballRadius + pegRadius + 2) {
                        const angle = Math.atan2(dy, dx);
                        const bounceAngle = angle + (Math.random() * 0.5 - 0.25);
                        
                        this.vx = Math.cos(bounceAngle) * bounceVelocity;
                        this.vy = Math.abs(Math.sin(bounceAngle) * bounceVelocity);
                        
                        this.x = pegX + (ballRadius + pegRadius + 2) * Math.cos(angle);
                        this.y = pegY + (ballRadius + pegRadius + 2) * Math.sin(angle);
                    }
                }
            }
            
            // Boundary checks
            if (this.x < ballRadius) {
                this.x = ballRadius;
                this.vx *= -0.5;
            } else if (this.x > boardWidth - ballRadius) {
                this.x = boardWidth - ballRadius;
                this.vx *= -0.5;
            }
            
            // Check if ball reached bottom
            if (this.y >= boardHeight - 80) {
                this.finished = true;
                this.y = boardHeight - 80;
                this.vy = 0;
                this.vx = 0;
                this.bin = Math.floor((this.x / boardWidth) * 13);
                this.bin = Math.max(0, Math.min(12, this.bin));
                distribution[this.bin]++;
            }
        }
    }
    
    function animate() {
        if (!isAnimating) return;
        
        balls = balls.map(ball => {
            ball.move();
            return ball;
        });
        
        animationFrameId = requestAnimationFrame(animate);
    }
    
    let ballAddInterval: number;
    
    function startAnimation() {
        if (isAnimating) return;
        
        isAnimating = true;
        balls = [];
        distribution = Array(13).fill(0);
        animate();
        ballAddInterval = setInterval(() => {
            if (balls.length < totalBalls) {
                balls = [...balls, new Ball()];
            } else {
                stopAnimation();
            }
        }, 100);  // Slowed down ball generation interval
    }
    
    function stopAnimation() {
        if (animationFrameId) {
            cancelAnimationFrame(animationFrameId);
            animationFrameId = null;
        }
        clearInterval(ballAddInterval);
        isAnimating = false;
    }
    
    onDestroy(() => {
        stopAnimation();
    });
  </script>
  
  <div class="pendulum-container">
    <svg width={boardWidth} height={boardHeight} viewBox={`0 0 ${boardWidth} ${boardHeight}`}>
        <!-- Pegs -->
        {#each Array(levels) as _, level}
            {@const pegsInRow = 1 + level}  // Start with 1 peg
            {@const rowWidth = (pegsInRow - 1) * pegSpacing}
            {@const startX = (boardWidth - rowWidth) / 2}
            
            {#each Array(pegsInRow) as _, i}
                {@const pegX = startX + i * pegSpacing}
                {@const pegY = 80 + level * pegSpacing}
                <circle 
                    cx={pegX} 
                    cy={pegY} 
                    r={pegRadius}
                    class="peg"
                />
            {/each}
        {/each}
        
        <!-- Balls -->
        {#each balls as ball}
            <circle 
                cx={ball.x} 
                cy={ball.y} 
                r={ballRadius}
                class="ball"
            />
        {/each}
        
        <!-- Distribution -->
        {#each distribution as count, i}
            {@const height = count ? (count / Math.max(...distribution)) * 120 : 0}
            {@const x = (boardWidth / 13) * i}
            <rect 
                x={x + 2}
                y={boardHeight - height - 40}
                width={(boardWidth / 13) - 4}
                height={height}
                class="distribution-bar"
            />
            <text 
                x={x + (boardWidth / 26)}
                y={boardHeight - 20}
                text-anchor="middle"
                class="distribution-text"
                font-size="14"
            >
                {count}
            </text>
        {/each}
    </svg>
    
    <div class="controls">
        <button on:click={isAnimating ? stopAnimation : startAnimation}>
            {isAnimating ? 'Stop' : 'Start'}
        </button>
    </div>
  </div>
  
  <style>
    /* Light mode (default) */
    :global(:root) {
        --pendulum-line-color: #000;
        --pendulum-bob-fill: #fff;
        --text-color: #000;
        --button-bg: transparent;
        --button-text: #000;
        --button-border: #000;
        --button-hover-bg: rgba(0,0,0,0.1);
        --distribution-bar-color: rgba(0,0,0,0.2);
        --ball-color: #000;
        --peg-fill: #fff;
        --peg-stroke: #000;
    }
  
    /* Dark mode */
    @media (prefers-color-scheme: dark) {
        :global(:root) {
            --pendulum-line-color: #f0f0f0;
            --pendulum-bob-fill: rgba(240, 240, 240, 0.1);
            --text-color: #f0f0f0;
            --button-bg: transparent;
            --button-text: #f0f0f0;
            --button-border: #f0f0f0;
            --button-hover-bg: rgba(255,255,255,0.1);
            --distribution-bar-color: rgba(240,240,240,0.2);
            --ball-color: #f0f0f0;
            --peg-fill: rgba(240, 240, 240, 0.1);
            --peg-stroke: #f0f0f0;
        }
    }
  
    .pendulum-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        padding: 2rem;
        overflow: visible;
    }
  
    svg {
        overflow: visible;
        max-width: 100%;
        height: auto;
    }
  
    .peg {
        fill: var(--peg-fill);
        stroke: var(--peg-stroke);
        stroke-width: 1;
    }
  
    .ball {
        fill: var(--ball-color);
    }
  
    .distribution-bar {
        fill: var(--distribution-bar-color);
    }
  
    .distribution-text {
        fill: var(--text-color);
    }
  
    .controls {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
    }
  
    button {
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        font-size: 1rem;
        font-weight: 500;
        background-color: var(--button-bg);
        color: var(--button-text);
        border: 1px solid var(--button-border);
        padding: 0.5rem 1rem;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s ease;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
  
    button:hover {
        background-color: var(--button-hover-bg);
    }
  </style>