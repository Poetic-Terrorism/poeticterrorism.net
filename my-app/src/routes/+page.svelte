<script>
	let src = '/sheep.jpeg';
	let name = 'sheep';
</script>

<div class="image-container">
	<img {src} alt="{name}" class="responsive-image" />
</div>

<style>
	.image-container {
		/* Centered layout with minimal vertical padding */
		display: flex;
		justify-content: center; /* Horizontal centering */
		align-items: center; /* Vertical centering */
		min-height: 10vh; /* Reduced from 100vh to create less vertical padding */
		width: 100%;
		padding: 0;
		margin: 0;
	}

	.responsive-image {
		/* Responsive sizing */
		max-width: 100%; /* Never exceed the width of its container */
		height: auto; /* Maintain aspect ratio */
		width: 100%; /* Full width on small screens */
		max-width: 600px; /* Maximum width on larger screens */
		
		/* Optional: add some subtle styling */
		object-fit: contain; /* Ensures the entire image is visible */
		border-radius: 8px; /* Soft rounded corners */
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
	}

	/* Responsive breakpoints */
	@media (min-width: 768px) {
		.responsive-image {
			width: 80%; /* Slightly narrower on medium screens */
		}
	}

	@media (min-width: 1024px) {
		.responsive-image {
			width: 60%; /* Even narrower on large screens */
		}
	}
</style>