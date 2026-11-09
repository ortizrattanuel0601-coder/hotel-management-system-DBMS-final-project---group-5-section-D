const API = '/api/maintenance';
const PRIORITIES = ['Low', 'Medium', 'High', 'Urgent'];
const JSON_HEADERS = { 'Content-Type': 'application/json' };

const form = document.getElementById('maintenance-form');
const formTitle = document.getElementById('form-title');
const idInput = document.getElementById('request-id');
const roomSelect = document.getElementById('room-select');
const itemInput = document.getElementById('item-input');
const issueInput = document.getElementById('issue-input');
const prioritySelect = document.getElementById('priority-select');
const employeeSelect = document.getElementById('employee-select');
const dateInput = document.getElementById('date-input');
const saveButton = document.getElementById('save-button');
const cancelButton = document.getElementById('cancel-button');
const formMessage = document.getElementById('form-message');
const statusFilter = document.getElementById('status-filter');
const tableMessage = document.getElementById('table-message');
const tableBody = document.getElementById('request-table-body');
const reportButton = document.getElementById('report-button');
const reportMessage = document.getElementById('report-message');
const reportBody = document.getElementById('report-table-body');

let requests = [];

function escapeHtml(value) {
    return String(value ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function setMessage(element, text, type) {
    element.textContent = text || '';
    element.className = 'mt-message' + (type ? ' ' + type : '');
}

async function request(url, options) {
    const response = await fetch(url, options);
    let result = null;

    try {
        result = await response.json();
    } catch (error) {
        result = null;
    }

    if (!response.ok || !result || result.success === false) {
        throw new Error((result && result.message) || 'Request failed.');
    }

    return result;
}

function badgeClass(priority) {
    return String(priority || '').toLowerCase().replace(/[^a-z]+/g, '-');
}

// Keeps an old value (for example from the seed data) selectable when editing.
function ensureOption(select, value) {
    if (!value) return;

    const exists = Array.from(select.options).some(
        (option) => option.value === value
    );

    if (!exists) {
        const option = document.createElement('option');
        option.value = value;
        option.textContent = value;
        select.appendChild(option);
    }
}

/* ---------- Form ---------- */

function buildPriorityOptions() {
    prioritySelect.innerHTML =
        '<option value="">Choose a priority</option>' +
        PRIORITIES.map((p) => `<option value="${p}">${p}</option>`).join('');
}

async function loadOptions() {
    try {
        const result = await request(API + '/options');
        const { rooms, employees } = result.data;

        roomSelect.innerHTML =
            '<option value="">Choose a room</option>' +
            rooms.map((room) =>
                `<option value="${room.room_id}">Room ${escapeHtml(room.room_number)}</option>`
            ).join('');

        employeeSelect.innerHTML =
            '<option value="">Unassigned</option>' +
            employees.map((employee) =>
                `<option value="${employee.employee_id}">${escapeHtml(employee.employee_name)}</option>`
            ).join('');
    } catch (error) {
        setMessage(formMessage, error.message, 'error');
    }
}

function resetForm() {
    form.reset();
    idInput.value = '';
    formTitle.textContent = 'Add Maintenance Request';
    saveButton.textContent = 'Save Request';
    cancelButton.hidden = true;
}

function startEdit(id) {
    const item = requests.find((row) => row.maintenance_id === id);
    if (!item) return;

    ensureOption(prioritySelect, item.priority);

    idInput.value = item.maintenance_id;
    roomSelect.value = String(item.room_id);
    itemInput.value = item.maintenance_items;
    issueInput.value = item.issue_description;
    prioritySelect.value = item.priority;
    employeeSelect.value = item.employee_id ? String(item.employee_id) : '';
    dateInput.value = item.request_date || '';

    formTitle.textContent = 'Edit Request #' + item.maintenance_id;
    saveButton.textContent = 'Update Request';
    cancelButton.hidden = false;
    setMessage(formMessage, '');
    form.scrollIntoView({ behavior: 'smooth' });
}

cancelButton.addEventListener('click', () => {
    resetForm();
    setMessage(formMessage, '');
});

form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const id = idInput.value;
    const body = {
        room_id: Number(roomSelect.value),
        employee_id: employeeSelect.value === '' ? null : Number(employeeSelect.value),
        issue_description: issueInput.value.trim(),
        priority: prioritySelect.value,
        maintenance_items: itemInput.value.trim(),
        request_date: dateInput.value || null
    };

    const originalText = saveButton.textContent;
    saveButton.disabled = true;
    saveButton.textContent = 'Saving...';

    try {
        const result = await request(id ? `${API}/${id}` : API, {
            method: id ? 'PUT' : 'POST',
            headers: JSON_HEADERS,
            body: JSON.stringify(body)
        });

        resetForm();
        setMessage(formMessage, result.message, 'success');
        await loadRequests();
    } catch (error) {
        saveButton.textContent = originalText;
        setMessage(formMessage, error.message, 'error');
    } finally {
        saveButton.disabled = false;
    }
});

/* ---------- Request list ---------- */

function renderRequests() {
    const filter = statusFilter.value;

    const rows = requests.filter((row) => {
        if (filter === 'open') return !row.completed_date;
        if (filter === 'completed') return Boolean(row.completed_date);
        return true;
    });

    if (rows.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="9">No maintenance requests found.</td></tr>';
        return;
    }

    tableBody.innerHTML = rows.map((row) => `
        <tr>
            <td>${escapeHtml(row.maintenance_id)}</td>
            <td>${escapeHtml(row.room_number)}${row.type_name ? ' (' + escapeHtml(row.type_name) + ')' : ''}</td>
            <td>${escapeHtml(row.maintenance_items)}</td>
            <td class="mt-issue">${escapeHtml(row.issue_description)}</td>
            <td><span class="mt-badge ${badgeClass(row.priority)}">${escapeHtml(row.priority)}</span></td>
            <td>${row.employee_name ? escapeHtml(row.employee_name) : 'Unassigned'}</td>
            <td>${escapeHtml(row.request_date || '')}</td>
            <td>${row.completed_date ? escapeHtml(row.completed_date) : 'Open'}</td>
            <td>
                <div class="mt-actions">
                    <button type="button" data-action="edit" data-id="${row.maintenance_id}">Edit</button>
                    ${row.completed_date ? '' : `<button type="button" data-action="complete" data-id="${row.maintenance_id}">Complete</button>`}
                    <button type="button" class="danger" data-action="delete" data-id="${row.maintenance_id}">Delete</button>
                </div>
            </td>
        </tr>
    `).join('');
}

async function loadRequests() {
    setMessage(tableMessage, 'Loading requests...');

    try {
        const result = await request(API);
        requests = result.data;
        renderRequests();
        setMessage(tableMessage, '');
    } catch (error) {
        setMessage(tableMessage, error.message, 'error');
    }
}

async function completeRequest(id) {
    try {
        const result = await request(`${API}/${id}/complete`, { method: 'PATCH' });
        setMessage(tableMessage, result.message, 'success');
        await loadRequests();
    } catch (error) {
        setMessage(tableMessage, error.message, 'error');
    }
}

async function removeRequest(id) {
    if (!confirm('Delete maintenance request #' + id + '?')) return;

    try {
        const result = await request(`${API}/${id}`, { method: 'DELETE' });
        setMessage(tableMessage, result.message, 'success');
        await loadRequests();
    } catch (error) {
        setMessage(tableMessage, error.message, 'error');
    }
}

tableBody.addEventListener('click', (event) => {
    const button = event.target.closest('button[data-action]');
    if (!button) return;

    const id = Number(button.dataset.id);

    if (button.dataset.action === 'edit') startEdit(id);
    if (button.dataset.action === 'complete') completeRequest(id);
    if (button.dataset.action === 'delete') removeRequest(id);
});

statusFilter.addEventListener('change', renderRequests);

/* ---------- FULL OUTER JOIN report ---------- */

reportButton.addEventListener('click', async () => {
    setMessage(reportMessage, 'Loading report...');
    reportButton.disabled = true;

    try {
        const result = await request(API + '/reports/employee-workload');
        const rows = result.data;

        if (rows.length === 0) {
            reportBody.innerHTML = '<tr><td colspan="8">No data found.</td></tr>';
        } else {
            reportBody.innerHTML = rows.map((row) => {
                const rowClass =
                    row.assignment_status === 'Unassigned request' ? 'mt-flag'
                    : row.assignment_status === 'No requests' ? 'mt-idle'
                    : '';

                return `
                    <tr class="${rowClass}">
                        <td>${row.employee_name ? escapeHtml(row.employee_name) : 'Unassigned'}</td>
                        <td>${escapeHtml(row.assignment_status)}</td>
                        <td>${row.maintenance_id ? '#' + escapeHtml(row.maintenance_id) : ''}</td>
                        <td>${escapeHtml(row.room_number || '')}</td>
                        <td class="mt-issue">${escapeHtml(row.issue_description || '')}</td>
                        <td>${row.priority ? `<span class="mt-badge ${badgeClass(row.priority)}">${escapeHtml(row.priority)}</span>` : ''}</td>
                        <td>${escapeHtml(row.request_date || '')}</td>
                        <td>${escapeHtml(row.completed_date || '')}</td>
                    </tr>
                `;
            }).join('');
        }

        setMessage(reportMessage, '');
    } catch (error) {
        setMessage(reportMessage, error.message, 'error');
    } finally {
        reportButton.disabled = false;
    }
});

buildPriorityOptions();
loadOptions();
loadRequests();