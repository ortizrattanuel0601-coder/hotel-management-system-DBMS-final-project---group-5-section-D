
const mainContent = document.getElementById("main-content");
const navigationLinks = document.querySelectorAll(".sidebar nav a");

// Page information
const pages = {
    dashboard: {
        title: "Dashboard",
        description: "Manage your hotel operations in one place."
    },

    guests: {
        title: "Guest Management",
        description: "Manage registered hotel guests."
    },

    rooms: {
        title: "Room Management",
        description: "Manage hotel rooms and their availability."
    },

    reservations: {
        title: "Reservations",
        description: "Manage guest bookings and reservations."
    },

    employees: {
        title: "Employee Management",
        description: "Manage hotel employees."
    },

    services: {
        title: "Hotel Services",
        description: "Manage the services offered by the hotel."
    },

    "service-orders": {
        title: "Service Orders",
        description: "Manage guest service requests."
    }
};


// Display the selected page
function showPage(pageName) {

    const page = pages[pageName];

    if (!page) return;

    // Update active navigation link
    navigationLinks.forEach(link => {
        link.classList.toggle(
            "active",
            link.dataset.page === pageName
        );
    });

    // Display page content
    if (pageName === "dashboard") {
        mainContent.innerHTML = `
            <header class="topbar">
                <div>
                    <p class="welcome-text">WELCOME BACK</p>
                    <h1>Dashboard</h1>
                    <p class="description">
                        Manage your hotel operations in one place.
                    </p>
                </div>
            </header>

            <section class="stats">

                <div class="stat-card">
                    <div class="stat-icon">G</div>
                    <h3>Total Guests</h3>
                    <p>0</p>
                    <span>Registered guests</span>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">R</div>
                    <h3>Total Rooms</h3>
                    <p>0</p>
                    <span>Available hotel rooms</span>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">B</div>
                    <h3>Reservations</h3>
                    <p>0</p>
                    <span>Total bookings</span>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">E</div>
                    <h3>Employees</h3>
                    <p>0</p>
                    <span>Registered employees</span>
                </div>

            </section>

            <section class="content-card">

                <div class="section-header">
                    <div>
                        <h2>Recent Reservations</h2>
                        <p>Overview of the latest hotel bookings.</p>
                    </div>

                    <button class="view-button">
                        View All
                    </button>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Reservation ID</th>
                                <th>Guest</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td colspan="5" class="empty-message">
                                    No reservations available.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </section>

            <footer>
                <p>© 2026 Lumière Grand. All Rights Reserved.</p>
            </footer>
        `;
    } else {
        mainContent.innerHTML = `
            <header class="topbar">
                <div>
                    <p class="welcome-text">LUMIÈRE GRAND</p>
                    <h1>${page.title}</h1>
                    <p class="description">${page.description}</p>
                </div>
            </header>

            <section class="content-card">
                <div class="section-header">
                    <div>
                        <h2>${page.title}</h2>
                        <p>${page.description}</p>
                    </div>
                </div>

                <p class="empty-message">
                    This section is being prepared.
                    Database integration will be added soon.
                </p>
            </section>

            <footer>
                <p>© 2026 Lumière Grand. All Rights Reserved.</p>
            </footer>
        `;
    }
}


// Listen for sidebar clicks
navigationLinks.forEach(link => {

    link.addEventListener("click", function(event) {

        event.preventDefault();

        const pageName = this.dataset.page;

        showPage(pageName);

    });

});


// Display dashboard when website opens
showPage("dashboard");

console.log("Lumière Grand frontend loaded successfully.");
