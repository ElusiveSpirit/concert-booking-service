(function(){
    "use strict";

    let wrapper = document.querySelector(".js-booking");
    let count = document.querySelector(".js-users-count");

    if (wrapper) {
        let form = wrapper.querySelector("form");
        let action = form.action.split("/");
        action = action[action.length - 1];

        form.addEventListener("submit", event => {
            event.preventDefault();

            let data = new FormData();
            data.append("json", JSON.stringify({
                _csrf_token: form.elements._csrf_token.value,
                concert_id: form.elements.concert_id.value
            }));

            fetch(`/api/${action}`, {
                method: "POST",
                body: data,
                credentials: "include"
            })
            .then(responce => responce.json())
            .then(data => {

                if (data.action) {
                    if (data.action === "create") {
                        form.querySelector("button").classList = "";
                        form.querySelector("button").innerHTML = "Unbook ticket";
                        wrapper.insertAdjacentHTML("afterBegin", "<span>You've booked a ticket</span>");
                        action = "unbook";
                        showInfo("You've booked a ticket");
                    } else {
                        form.querySelector("button").classList = "btn btn-primary";
                        form.querySelector("button").innerHTML = "Book ticket";
                        wrapper.removeChild(wrapper.querySelector("span"));
                        action = "book";
                        showInfo("You've unbooked a ticket");
                    }
                    form.action = action;
                    count.innerHTML = data.count;
                } else {
                    console.log(data);
                }
            });
        });
    }

    function showInfo(msg) {
        let p = document.createElement("p");
        p.classList = "alert alert-info";
        p.innerHTML = msg;
        p.setAttribute("role", "alert");

        document.querySelector("main").before(p);
        setTimeout(function(){
            p.parentNode.removeChild(p);
        }, 2000);
    }
})();
