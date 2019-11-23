up.compiler('.extendable', function(element) {

    let extender = element.querySelector('.extendable--extend')
    let extenderIcon = extender.querySelector('i')
    let maxHeight = getComputedStyle(element).maxHeight
    let height = element.scrollHeight
    let background = getComputedStyle(extender).background
    let extended = false

    if(isOverflown(element)){
        extender.classList.add('-visible')

        extender.addEventListener('click', function(){
            if((extended = !extended) === true){
                element.style.maxHeight = height + "px"
                extender.style.background= "linear-gradient(transparent, transparent)"
                extenderIcon.style.transform = "rotate(180deg)"
            }else{
                element.style.maxHeight = maxHeight
                extender.style.background = background
                extenderIcon.style.transform = "rotate(0deg)"
            }
        })
    }
})

function isOverflown(element) {
    return element.scrollHeight > element.clientHeight
}