up.compiler('.music', function(element){
    let queue_update = setInterval(() => up.replace('.music--queue, .music--playing', '/songs', { cache: false }), 1000)
    return () => clearInterval(queue_update)
})
