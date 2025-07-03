<!-- ThemeToggle.svelte -->
<script>
  let dark=false;
  const toggle=()=>{
    dark=!dark;
    document.documentElement.classList.toggle('dark',dark);
  };
</script>
<button on:click={toggle} class="p-2 rounded bg-gray-200 dark:bg-slate-700">
  {dark?'🌙':'☀️'}
</button>
