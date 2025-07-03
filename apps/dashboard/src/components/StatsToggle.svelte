<!-- StatsToggle.svelte -->
<script>
  export let mode;
</script>
<div class="flex gap-2">
  <button class:selected={mode==='overview'} on:click={()=>mode='overview'}>Overview</button>
  <button class:selected={mode==='data'} on:click={()=>mode='data'}>Data</button>
</div>
<style>
  .selected{font-weight:600;text-decoration:underline}
</style>
