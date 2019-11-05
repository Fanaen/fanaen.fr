(function() {
    const roles = window.roles;
    const roleElement = document.getElementById('roles');

    let state = 0;
    let letterCount = roles[0].length;
    let roleIndex = 0;

    function update() {
        let wait = 0;
        switch (state) {
            case 0: // Waiting
                wait = 5000;
                state = 1;
                break;
            case 1: // Reducing
                letterCount--;
                if (letterCount <= 0) {
                    const previousRole = roleIndex;
                    while (roleIndex === previousRole) roleIndex = Math.floor(Math.random() * roles.length);
                    state = 2;
                }
                wait = 300 / roles[roleIndex].length;
                break;
            case 2: // Growing
                letterCount++;
                if (letterCount >= roles[roleIndex].length) state = 0;
                wait = 300 / roles[roleIndex].length;
                break;
        }

        roleElement.innerHTML = roles[roleIndex].substring(0, letterCount);
        setTimeout(update, wait);
    }
    update();
})();