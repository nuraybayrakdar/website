console.log('Test');


document.getElementById('clickButton').addEventListener('click', function() {
    console.log('Butona tıkladınız');
    document.getElementById('message').textContent = 'Butona tıkladınız!';
});

var element = document.getElementById('elementId');
if (element) {
    // Element mevcutsa işlemi gerçekleştir
    console.log(element.parentElement);
} else {
    console.log('Element bulunamadı');
}
