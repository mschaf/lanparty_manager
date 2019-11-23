up.compiler('.flash', function(element){
    up.animate(element, 'move-from-top')
    let timeout = setTimeout(() => up.animate(element, 'move-to-right'), 3000)
    element.addEventListener('click', () =>  {
        clearTimeout(timeout)
        up.animate(element, 'move-to-right')
    })
    return () => clearTimeout(timeout)
})
