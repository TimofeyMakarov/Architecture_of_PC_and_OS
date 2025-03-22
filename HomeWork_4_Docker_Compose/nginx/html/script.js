function sendRequest(inputMessage){
    fetch('http://192.168.31.59:8080/api/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ message: inputMessage })})
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
            alert('Запрос выполнен! Результат в консоли.');
        })
    .catch(error => {
        console.error('Ошибка:', error);
        alert('Произошла ошибка при выполнении запроса.');
    });
}

document.getElementById('Select').addEventListener('click', function() {
    sendRequest('Select');
});
