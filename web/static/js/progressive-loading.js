(function (){
    "use strict";

    let btn = document.querySelector(".js-load-concert");
    let table = document.querySelector(".js-concert-list");

    if (btn) {
        btn.addEventListener("click", event => {
            event.preventDefault();
            let page = Number(btn.getAttribute("page")) + 1;

            fetch(`/api/concerts?page=${page}`)
                .then(responce => responce.json())
                .then(data => {
                    let html = data.data.map(renderHTML);
                    btn.setAttribute("page",  data.page);

                    table.insertAdjacentHTML("beforeEnd", html);
                });
        });
    }

    function renderHTML(obj) {
        return `
            <tr>
              <td>${obj.name}</td>
              <td>${obj.description}</td>
              <td>${obj.date}</td>
              <td><img src="${obj.picture}"></img></td>

              <td class="text-right">
                <a class="btn btn-default btn-xs" href="/concerts/${obj.id}">Show</a>
                <a class="btn btn-default btn-xs" href="/concerts/${obj.id}/edit">Edit</a>
              </td>
            </tr>
        `;
    }

})();
