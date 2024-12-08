<script lang="ts">
    import { onMount, onDestroy } from 'svelte';

    // Pendulum parameters
    const g = 9.81;  // gravity (m/s^2)
    const L = 230;   // length of pendulum (pixels)
    const dt = 0.15; // time step (s)
    const t_max = 10; // simulation time (s)

    // Initial conditions
    let thetaEuler = Math.PI / 4;  // initial angle (rad) for Euler method
    let omegaEuler = 0.0;          // initial angular velocity (rad/s)
    let currentThetaEuler = thetaEuler;

    let thetaRK = Math.PI / 4;     // initial angle (rad) for Runge-Kutta method
    let omegaRK = 0.0;             // initial angular velocity (rad/s)
    let currentThetaRK = thetaRK;

    // Animation state
    let isAnimating = false;
    let animationFrameId: number | null = null;

    // Rotation detection
    let hasRotatedEuler = false;
    let rotationJokeDisplayed = false;
    let rotationJoke = '';

    // SVG dimensions
    const width = 800;
    const height = 500;

    function simulateEuler() {
        // Explicit Euler Method
        const thetaNew = currentThetaEuler + dt * omegaEuler;
        const omegaNew = omegaEuler - dt * (g / L) * Math.sin(currentThetaEuler);
        
        currentThetaEuler = thetaNew;
        omegaEuler = omegaNew;
        
        // Check for rotation
        if (Math.abs(currentThetaEuler) > Math.PI * 1.5 && !hasRotatedEuler) {
            hasRotatedEuler = true;
        }
        
        return currentThetaEuler;
    }

    function simulateRK() {
        // Runge-Kutta Method (4th Order)
        const k1_theta = omegaRK;
        const k1_omega = -(g / L) * Math.sin(currentThetaRK);
        
        const k2_theta = omegaRK + dt * k1_omega / 2;
        const k2_omega = -(g / L) * Math.sin(currentThetaRK + dt * k1_theta / 2);
        
        const k3_theta = omegaRK + dt * k2_omega / 2;
        const k3_omega = -(g / L) * Math.sin(currentThetaRK + dt * k2_theta / 2);
        
        const k4_theta = omegaRK + dt * k3_omega;
        const k4_omega = -(g / L) * Math.sin(currentThetaRK + dt * k3_theta);
        
        // Update theta and omega
        currentThetaRK += dt * (k1_theta + 2 * k2_theta + 2 * k3_theta + k4_theta) / 6;
        omegaRK += dt * (k1_omega + 2 * k2_omega + 2 * k3_omega + k4_omega) / 6;
        
        return currentThetaRK;
    }

    function animate() {
        if (!isAnimating) return;

        simulateEuler();
        simulateRK();

        // Display rotation joke when Euler method pendulum starts rotating
        if (hasRotatedEuler && !rotationJokeDisplayed) {
            rotationJoke = "Looks like this Euler pendulum just decided to break Newton's laws and become a helicopter! 🚁 Apparently, conservation of energy is more of a suggestion than a rule.";
            rotationJokeDisplayed = true;
        }

        animationFrameId = requestAnimationFrame(animate);
    }

    function startAnimation() {
        if (isAnimating) return;

        // Reset initial conditions
        thetaEuler = Math.PI / 4;
        omegaEuler = 0.0;
        currentThetaEuler = thetaEuler;

        thetaRK = Math.PI / 4;
        omegaRK = 0.0;
        currentThetaRK = thetaRK;

        hasRotatedEuler = false;
        rotationJokeDisplayed = false;
        rotationJoke = '';

        isAnimating = true;
        animate();
    }

    function stopAnimation() {
        if (animationFrameId) {
            cancelAnimationFrame(animationFrameId);
            animationFrameId = null;
        }
        isAnimating = false;

        // Reset initial conditions
        thetaEuler = Math.PI / 4;
        omegaEuler = 0.0;
        currentThetaEuler = thetaEuler;

        thetaRK = Math.PI / 4;
        omegaRK = 0.0;
        currentThetaRK = thetaRK;
    }

    // Calculate pendulum bob and rod position for Euler method
    $: bobXEuler = width / 4 + L * Math.sin(currentThetaEuler);
    $: bobYEuler = 200 + L * Math.cos(currentThetaEuler);

    // Calculate pendulum bob and rod position for Runge-Kutta method
    $: bobXRK = 3 * width / 4 + L * Math.sin(currentThetaRK);
    $: bobYRK = 200 + L * Math.cos(currentThetaRK);

    // Cleanup function to stop animation when component is destroyed
    onDestroy(() => {
        if (animationFrameId) {
            cancelAnimationFrame(animationFrameId);
        }
    });
</script>

<div class="pendulum-container">
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}>
        <!-- Euler Method Pendulum -->
        <line 
            x1={width / 4} 
            y1="200" 
            x2={bobXEuler} 
            y2={bobYEuler} 
            stroke="var(--pendulum-line-color)" 
            stroke-width="2"
        />
        
        <circle 
            cx={bobXEuler} 
            cy={bobYEuler} 
            r="20" 
            fill="var(--pendulum-bob-fill)" 
            stroke="var(--pendulum-line-color)" 
            stroke-width="2"
        />

        <!-- Runge-Kutta Method Pendulum -->
        <line 
            x1={3 * width / 4} 
            y1="200" 
            x2={bobXRK} 
            y2={bobYRK} 
            stroke="var(--pendulum-line-color)" 
            stroke-width="2"
        />
        
        <circle 
            cx={bobXRK} 
            cy={bobYRK} 
            r="20" 
            fill="var(--pendulum-bob-fill)" 
            stroke="var(--pendulum-line-color)" 
            stroke-width="2"
        />

        <!-- Labels -->
        <text 
            x={width / 4} 
            y="50" 
            text-anchor="middle" 
            font-size="16" 
            fill="var(--text-color)"
        >
            Euler Method
        </text>
        <text 
            x={3 * width / 4} 
            y="50" 
            text-anchor="middle" 
            font-size="16" 
            fill="var(--text-color)"
        >
            Runge-Kutta Method
        </text>
    </svg>

    <div class="controls">
        <button 
            on:click={isAnimating ? stopAnimation : startAnimation}
        >
            {isAnimating ? 'Stop' : 'Start'} Animation
        </button>
    </div>

    {#if rotationJoke}
        <div class="rotation-joke">
            {rotationJoke}
        </div>
    {/if}
</div>

<style>
    /* Light mode (default) */
    :root {
        --pendulum-line-color: #000;
        --pendulum-bob-fill: #fff;
        --text-color: #000;
        --button-bg: #f0f0f0;
        --button-border: #333;
        --button-hover-bg: #e0e0e0;
        --joke-bg: #f0f0f0;
        --joke-text: #333;
    }

    /* Dark mode */
    @media (prefers-color-scheme: dark) {
        :root {
            --pendulum-line-color: #f0f0f0;
            --pendulum-bob-fill: rgba(240, 240, 240, 0.1);
            --text-color: #f0f0f0;
            --button-bg: #333;
            --button-border: #f0f0f0;
            --button-hover-bg: #444;
            --joke-bg: #444;
            --joke-text: #f0f0f0;
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

    .controls {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
    }

    button {
        padding: 0.5rem 1rem;
        background-color: var(--button-bg);
        border: 1px solid var(--button-border);
        border-radius: 4px;
        color: var(--text-color);
        cursor: pointer;
        transition: background-color 0.3s;
        touch-action: manipulation;
    }

    button:hover {
        background-color: var(--button-hover-bg);
    }

    .rotation-joke {
        margin-top: 1rem;
        padding: 1rem;
        background-color: var(--joke-bg);
        color: var(--joke-text);
        border-radius: 8px;
        text-align: center;
        max-width: 80%;
    }
</style>