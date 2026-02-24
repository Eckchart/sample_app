// Menu manipulation

// Adds a toggle listener.
function addToggleListener(selected_id, menu_id, toggle_class) {
    let selected_element = document.querySelector(`#${selected_id}`);

    // In the case of adding an event listener for the element
    // with id = `account`:
    // If we are NOT logged in, `selected_element` will be null,
    // since there was no element rendered with id = `account`, so
    // we first need to check if `selected_element` actually holds
    // the html object with id = `account` (i.e., isn't null) before
    // adding an event listener to it.
    if (selected_element) {
        selected_element.addEventListener("click", function(event) {
            event.preventDefault();
            let menu = document.querySelector(`#${menu_id}`);
            menu.classList.toggle(toggle_class);
        });
    }
}

// Add toggle listeners to listen for clicks.
document.addEventListener("turbo:load", function() {
    addToggleListener("account", "dropdown-menu", "active");
    addToggleListener("hamburger", "navbar-menu", "collapse");
});
