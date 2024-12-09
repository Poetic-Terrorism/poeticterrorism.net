<script lang="ts">
	import { onDestroy } from 'svelte';

	let src = '/sheep.jpeg';
	let walkImages = ['/walk1.svg', '/walk2.svg', '/walk3.svg'];

	// 羊のデータ型を定義
	interface WalkingSheep {
		id: number;
		image: string;
		imageIndex: number;
		progress: number;
		startY: number;
		speed: number;
		interval: ReturnType<typeof setInterval> | null;
		animationFrame: number | null;
	}

	let walkingSheep: WalkingSheep[] = [];

	function createWalkingSheep() {
		const startY = Math.random() * (window.innerHeight - 200); // ランダムな垂直位置
		
		// 歩行速度をランダムに設定
		const walkSpeed = 0.3 + 2*Math.random();
		
		const newSheep: WalkingSheep = {
			id: Date.now(),
			image: walkImages[0],
			imageIndex: 0,
			progress: -10, // 画面の左外から開始
			startY: startY,
			speed: walkSpeed,
			interval: null,
			animationFrame: null
		};

		// 歩行画像のアニメーション（速度を遅くする）
		newSheep.interval = setInterval(() => {
			newSheep.imageIndex = (newSheep.imageIndex + 1) % walkImages.length;
			newSheep.image = walkImages[newSheep.imageIndex];
		}, 300/walkSpeed); // 200msから300msに変更

		// 移動アニメーション
		const animationStart = Date.now();
		const baseAnimationDuration = 30000; // アニメーション時間を延長
		const animate = () => {
			const elapsedTime = Date.now() - animationStart;
			
			// 速度に応じて進捗を計算
			newSheep.progress = 5 + (elapsedTime / (baseAnimationDuration / newSheep.speed)) * 240;

			// アニメーションフレームを更新
			newSheep.animationFrame = requestAnimationFrame(animate);

			// 画面右端に達したら停止
			if (newSheep.progress >= 110) {
				// 羊を削除
				walkingSheep = walkingSheep.filter(s => s.id !== newSheep.id);
				if (newSheep.interval) clearInterval(newSheep.interval);
				if (newSheep.animationFrame) cancelAnimationFrame(newSheep.animationFrame);
			}

			// コンポーネントを強制的に更新
			walkingSheep = walkingSheep;
		};

		requestAnimationFrame(animate);
		walkingSheep = [...walkingSheep, newSheep];
	}

	onDestroy(() => {
		walkingSheep.forEach(sheep => {
			if (sheep.interval) clearInterval(sheep.interval);
			if (sheep.animationFrame) cancelAnimationFrame(sheep.animationFrame);
		});
	});
</script>

<div class="page-container">
	<div class="image-container">
		<img 
			{src} 
			alt="Static Sheep" 
			class="static-sheep"
		/>
	</div>

	<div class="button-container">
		<button 
			on:click={createWalkingSheep} 
			class="generate-sheep-btn"
			aria-label="Generate walking sheep"
		>
			<span class="btn-text">Walk a Sheep</span>
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right">
				<line x1="5" y1="12" x2="19" y2="12"></line>
				<polyline points="12 5 19 12 12 19"></polyline>
			</svg>
		</button>
	</div>

	{#each walkingSheep as sheep (sheep.id)}
		<img 
			src={sheep.image} 
			alt="Walking Sheep" 
			class="walking-sheep" 
			style="
				left: {sheep.progress}%; 
				top: {sheep.startY}px;
			"
		/>
	{/each}
</div>

<style>
	.page-container {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		width: 100%;
		padding: 20px;
		gap: 20px;
	}

	.image-container {
		display: flex;
		justify-content: center;
		width: 100%;
		max-width: 600px;
	}

	.static-sheep {
		max-width: 100%;
		height: auto;
		border-radius: 8px;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	}

	.button-container {
		display: flex;
		justify-content: center;
		width: 100%;
	}

	.generate-sheep-btn {
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 12px 24px;
		background-color: #4a4a4a;
		color: white;
		border: none;
		border-radius: 30px;
		cursor: pointer;
		transition: all 0.3s ease;
		gap: 10px;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 1px;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	}

	.generate-sheep-btn:hover {
		background-color: #5a5a5a;
		transform: translateY(-2px);
		box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
	}

	.generate-sheep-btn svg {
		width: 20px;
		height: 20px;
	}

	.walking-sheep {
		position: fixed;
		max-height: 100px; /* 元のサイズの1.5倍 */
		width: auto;
		z-index: 10;
		transition: all 0.5s linear;
	}
</style>