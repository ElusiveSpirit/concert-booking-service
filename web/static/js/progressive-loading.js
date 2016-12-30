(function (){
    "use strict";

    let btn = document.querySelector(".js-load-concert");
    let table = document.querySelector(".js-concert-list");
    let already = false;

    if (btn) {
        btn.addEventListener("click", event => {
            event.preventDefault();
            already = true;
            let page = Number(btn.getAttribute("page")) + 1;

            fetch(`/api/concerts?page=${page}`)
                .then(responce => responce.json())
                .then(data => {
                    let html = data.data.map(renderHTML);
                    btn.setAttribute("page",  data.page);

                    table.insertAdjacentHTML("beforeEnd", html);
                    already = false;
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

	window.onscroll = function() {
		var scrollHeight = Math.max(
			document.body.scrollHeight, document.documentElement.scrollHeight,
			document.body.offsetHeight, document.documentElement.offsetHeight,
			document.body.clientHeight, document.documentElement.clientHeight
		);
		var scrolled = window.pageYOffset || document.documentElement.scrollTop;
		if (!already && scrollHeight - scrolled <= document.documentElement.clientHeight + 200) {
		    btn.click();
		}
	}
})();
