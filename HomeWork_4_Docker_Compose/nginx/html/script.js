function sendRequest(inputMessage){
    fetch('http://localhost:8080/api/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(JSON.parse(inputMessage))})
    .then(response => response.json())
    .then(data => {
            const tableBody = document.querySelector('#dataTable tbody');
            tableBody.innerHTML = '';  // Очистка таблицы

            data.forEach(row => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${row.name}</td>
                    <td>${row.number}</td>
                    <td>${row.notes}</td>
                `;
                tableBody.appendChild(tr);
            });
            console.log('Ответ от сервера:', data);
            alert('Запрос выполнен!');
        })
    .catch(error => {
        console.error('Ошибка:', error);
       alert('Произошла ошибка при выполнении запроса.');    });
}
// всплывающие окна
// Функция для открытия всплывающего окна
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.style.display = 'block';
}
// Функция для закрытия окна
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.style.display = 'none';
}
// Закрытие окна при клике на крестик
document.querySelectorAll('.close').forEach(closeBtn => {
    closeBtn.addEventListener('click', function() {     
        const modal = this.closest('.modal');
        modal.style.display = 'none';    });
});
// Закрытие окна при клике вне его области
window.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
});

// Открытие окон при нажатии на кнопки
document.getElementById('Insert').addEventListener('click', function() {
    openModal('insertModal');
});

document.getElementById('Delete').addEventListener('click', function() {
    openModal('deleteModal');
});

document.getElementById('Edit').addEventListener('click', function() {
    openModal('editModal');
});
// Обработка отправки форм
document.getElementById('insertForm').addEventListener('submit', function(event) {
    event.preventDefault();
    // Собираем значения из полей ввода
    const name = document.querySelectorAll('insertName').value;
    const number = document.querySelectorAll('insertNumber').value;
    const notes = document.querySelectorAll('insertNotes').value;
    // Преобразуем в массивы значений
    //const nameArray = Array.from(names).map(input => input.value);
    //const numberArray = Array.from(numbers).map(input => input.value);
    //const notesArray = Array.from(notes).map(input => input.value);
    const data = {
        command: "insert",
        name: name,
        number: number,
        notes: notes
    };
    const jsonData = JSON.stringify(data, null, 2)
    // Выводим JSON в консоль для проверки
    console.log(jsonData);
    sendRequest(jsonData)
    closeModal('insertModal');
});
document.getElementById('deleteForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const name = document.getElementById('name').value;
    const number = document.getElementById('number').value;
    const notes = document.getElementById('notes').value;
    const data = {
        command: "delete",
        name: name,
        number: number,
        notes: notes
    };
    const jsonData = JSON.stringify(data, null, 2);
    console.log(jsonData);
    sendRequest(jsonData);
    closeModal('deleteModal');
});


document.getElementById('Select').addEventListener('click', function() {
    sendRequest('Select');
});
