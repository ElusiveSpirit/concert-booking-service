(function() {
    "use strict";

    let fab = document.querySelector(".fab");

    if (fab) {
        let modal = document.querySelector('.modal');
        let span = modal.querySelector(".close");
        let form = modal.querySelector("form");

        // When the user clicks on the button, open the modal
        fab.addEventListener("click", event => {
            event.preventDefault();
            modal.style.display = "block";
        });

        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }



        form.addEventListener("submit", event => {
            event.preventDefault();

            let hasError = false;
            let setError = (el, error) => {
                if (error) {
                    hasError = true;
                    el.parentNode.querySelector("span.help-block").innerHTML = error;
                    el.parentNode.classList.add("has-error");
                } else {
                    el.parentNode.querySelector("span.help-block").innerHTML = "";
                    el.parentNode.classList.remove("has-error");
                }
            };

            setError(concert_name);
            if (concert_name.value === "") {
                //setError(concert_name, "Can't be empty");
            }

            setError(concert_description);
            if (concert_description.value === "") {
                setError(concert_description, "Can't be empty");
            }

            setError(concert_picture);
            if (concert_picture.value === "") {
                setError(concert_picture, "Can't be empty");
            } else {
                let end = concert_picture.value.split(".");
                end = end[end.length - 1];

                if (["png", "jpg", "bmp", "jpeg"].indexOf(end) === -1) {
                    setError(concert_picture, "File must be a picture");
                }
            }

            if (!hasError) {
                let data = new FormData();
                data.append("json", JSON.stringify({
                    concert_name: concert_name.value,
                    concert_description: concert_description.value,
                    concert_picture: concert_picture.value
                }));

                fetch("/api/concerts/create", {
                    method: "POST",
                    body: new FormData(form)
                })
                .then(responce => responce.json())
                .then(data => {
                    console.log(data);
                    if (data.redirect_url) {
                        location.href = data.redirect_url;
                        return;
                    }
                    let errorBlock = form.querySelector(".alert.alert-danger");
                    if (!errorBlock){
                        errorBlock = document.createElement("div");
                        errorBlock.classList = "alert alert-danger";
                        form.prepend(errorBlock);
                    }
                    errorBlock.innerHTML = `<p>${data.errors}</p>`;
                });
            }
        });
    }
})();
