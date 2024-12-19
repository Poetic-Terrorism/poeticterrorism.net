<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  
  type Planet = {
    name: string;
    semiMajorAxis: number;
    period: number;
    trailLength: number;
  };
  
  const planets: Planet[] = [
    { name: '水星', semiMajorAxis: 0.387, period: 0.24, trailLength: 3000 },
    { name: '金星', semiMajorAxis: 0.723, period: 0.615, trailLength: 4000 },
    { name: '地球', semiMajorAxis: 1.0, period: 1.0, trailLength: 5000 },
    { name: '火星', semiMajorAxis: 1.524, period: 1.88, trailLength: 6000 },
    { name: '木星', semiMajorAxis: 5.203, period: 11.86, trailLength: 7000 },
    { name: '土星', semiMajorAxis: 9.537, period: 29.46, trailLength: 8000 },
    { name: '天王星', semiMajorAxis: 19.191, period: 84.01, trailLength: 90 },
    { name: '海王星', semiMajorAxis: 30.069, period: 164.79, trailLength: 100 },
  ];

  const moon = {
    semiMajorAxis: 0.0026,
    period: 0.074,
    trailLength: 20
  };

  type Position = { x: number; y: number };
  type Trail = Position[];

  let time = 0;
  const scale = 40;
  
  let svgWidth = 3000;
  let svgHeight = 3000;
  let centerX = svgWidth / 2;
  let centerY = svgHeight / 2;
  
  let animationId: number | null = null;
  let lastFrameTime: number | null = null;
  let isRunning = true;
  let isGeocentric = false;
  
  let planetTrails: { [key: string]: Trail } = {};
  let sunTrail: Trail = [];
  let moonTrail: Trail = [];

  function stopAnimation() {
    if (animationId !== null) {
      cancelAnimationFrame(animationId);
      animationId = null;
    }
    lastFrameTime = null;
  }

  function initializeTrails() {
    stopAnimation();
    
    planetTrails = planets.reduce((acc, planet) => {
      acc[planet.name] = [];
      return acc;
    }, {} as { [key: string]: Trail });
    sunTrail = [];
    moonTrail = [];
    time = 0;
    
    if (isRunning) {
      requestAnimationFrame(animate);
    }
  }

  function calculateHeliocentricPosition(semiMajorAxis: number, period: number, t: number) {
    const angle = (2 * Math.PI * t) / period;
    const x = centerX + semiMajorAxis * scale * Math.cos(angle);
    const y = centerY + semiMajorAxis * scale * Math.sin(angle);
    return { x, y };
  }

  function calculateGeocentricPosition(planet: Planet, t: number) {
    const earthAngle = (2 * Math.PI * t) / 1.0;
    const planetAngle = (2 * Math.PI * t) / planet.period;

    const earthX = Math.cos(earthAngle);
    const earthY = Math.sin(earthAngle);
    const planetX = planet.semiMajorAxis * Math.cos(planetAngle);
    const planetY = planet.semiMajorAxis * Math.sin(planetAngle);

    const relativeX = planetX - earthX;
    const relativeY = planetY - earthY;

    return {
      x: centerX + relativeX * scale,
      y: centerY + relativeY * scale
    };
  }

  function calculateMoonPosition(centerPos: Position, t: number) {
    const angle = (2 * Math.PI * t) / moon.period;
    const x = centerPos.x + moon.semiMajorAxis * scale * Math.cos(angle);
    const y = centerPos.y + moon.semiMajorAxis * scale * Math.sin(angle);
    return { x, y };
  }

  function calculatePosition(planet: Planet, t: number) {
    if (isGeocentric) {
      if (planet.name === '地球') {
        return { x: centerX, y: centerY };
      }
      return calculateGeocentricPosition(planet, t);
    }
    return calculateHeliocentricPosition(planet.semiMajorAxis, planet.period, t);
  }

  function calculateSunPosition(t: number) {
    const angle = (2 * Math.PI * t) / 1.0;
    return {
      x: centerX + scale * Math.cos(angle),
      y: centerY + scale * Math.sin(angle)
    };
  }

  function updateTrails() {
    planets.forEach(planet => {
      if (!(isGeocentric && planet.name === '地球')) {
        const pos = calculatePosition(planet, time);
        planetTrails[planet.name].push(pos);
        
        if (planetTrails[planet.name].length > planet.trailLength) {
          planetTrails[planet.name] = planetTrails[planet.name].slice(-planet.trailLength);
        }
      }
    });

    if (isGeocentric) {
      const sunPos = calculateSunPosition(time);
      sunTrail.push(sunPos);
      if (sunTrail.length > 500) {
        sunTrail = sunTrail.slice(-500);
      }
    }

    const earthPos = calculatePosition(planets.find(p => p.name === '地球')!, time);
    const moonPos = calculateMoonPosition(earthPos, time);
    moonTrail.push(moonPos);
    if (moonTrail.length > moon.trailLength) {
      moonTrail = moonTrail.slice(-moon.trailLength);
    }
  }

  function animate(currentTime: number) {
    if (lastFrameTime === null) {
      lastFrameTime = currentTime;
    }
    
    const deltaTime = (currentTime - lastFrameTime) / 1000; // Convert to seconds
    time += deltaTime * 0.3; // Adjust speed factor as needed
    
    lastFrameTime = currentTime;
    updateTrails();
    
    if (isRunning) {
      animationId = requestAnimationFrame(animate);
    }
  }

  function toggleSimulation() {
    isRunning = !isRunning;
    if (isRunning) {
      lastFrameTime = null;
      requestAnimationFrame(animate);
    } else {
      stopAnimation();
    }
  }

  function toggleSystem() {
    isGeocentric = !isGeocentric;
    initializeTrails();
  }

  function handleResize() {
    svgWidth = window.innerWidth * 0.5;
    svgHeight = window.innerHeight * 0.8;
    centerX = svgWidth / 2;
    centerY = svgHeight*0.8 / 2;
    initializeTrails();
  }

  onMount(() => {
    handleResize();
    window.addEventListener('resize', handleResize);
    initializeTrails();
    return () => {
      stopAnimation();
      window.removeEventListener('resize', handleResize);
    };
  });

  function createPathFromTrail(trail: Trail): string {
    if (trail.length < 2) return '';
    return trail.reduce((path, point, i) => 
      i === 0 ? `M ${point.x} ${point.y}` : `${path} L ${point.x} ${point.y}`,
      ''
    );
  }
</script>

<!-- SVGとスタイルの部分は変更なし -->
<div class="container">
  <svg width={svgWidth} height={svgHeight}>
    <rect width={svgWidth} height={svgHeight} fill="none"/>
    
    {#each Object.entries(planetTrails) as [name, trail]}
      {#if !(isGeocentric && name === '地球')}
        <path 
          d={createPathFromTrail(trail)} 
          class="planet-trail"
          fill="none"
        />
      {/if}
    {/each}

    {#if isGeocentric}
      <path 
        d={createPathFromTrail(sunTrail)} 
        class="planet-trail"
        fill="none"
      />
    {/if}

    <path 
      d={createPathFromTrail(moonTrail)} 
      class="moon-trail"
      fill="none"
    />
    
    <circle 
      cx={centerX} 
      cy={centerY} 
      r="10" 
      class="central-body"
    />
    <text
      x={centerX}
      y={centerY - 20}
      text-anchor="middle"
      class="body-label"
      font-size="12"
    >
      {isGeocentric ? 'Earth' : 'Sun'}
    </text>
    
    {#each planets as planet}
      {#if !(isGeocentric && planet.name === '地球')}
        {@const pos = calculatePosition(planet, time)}
        <circle
          cx={pos.x}
          cy={pos.y}
          r={planet.name === '地球' ? 6 : 4}
          class="planet"
        />

        {#if planet.name === '地球'}
          {@const moonPos = calculateMoonPosition(pos, time)}
          <circle
            cx={moonPos.x}
            cy={moonPos.y}
            r="2"
            class="moon"
          />
        {/if}
      {/if}
    {/each}

    {#if isGeocentric}
      {@const sunPos = calculateSunPosition(time)}
      <circle
        cx={sunPos.x}
        cy={sunPos.y}
        r="8"
        class="sun"
      />
    {/if}
  </svg>

  <div class="controls">
    <button on:click={toggleSimulation}>
      {isRunning ? 'Stop' : 'Start'}
    </button>
    <button on:click={toggleSystem}>
      {isGeocentric ? 'Heliocentric' : 'Geocentric'}
    </button>
  </div>
</div>

<style>
  /* Light mode (default) */
  :root {
    --planet-color: #000;
    --trail-color: #ddd;
    --text-color: #000;
    --button-bg: transparent;
    --button-text: #000;
    --button-border: #000;
    --button-hover-bg: rgba(0,0,0,0.1);
  }

  /* Dark mode */
  @media (prefers-color-scheme: dark) {
    :root {
      --planet-color: #fff;
      --trail-color: #444;
      --text-color: #fff;
      --button-bg: transparent;
      --button-text: #fff;
      --button-border: #fff;
      --button-hover-bg: rgba(255,255,255,0.1);
    }
  }

  .container {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 2rem;
    width: 100%;
    height: 100vh;
  }

  .controls {
    position: fixed;
    bottom: 2rem;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 1rem;
  }

  .planet-trail {
    stroke: var(--trail-color);
    stroke-width: 1;
  }

  .moon-trail {
    stroke: var(--trail-color);
    stroke-width: 0.5;
  }

  .central-body, .planet, .sun, .moon {
    fill: var(--planet-color);
  }

  .body-label {
    fill: var(--text-color);
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