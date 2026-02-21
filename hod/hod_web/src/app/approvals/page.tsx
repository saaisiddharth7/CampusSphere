export default function ApprovalsPage() {
    const requests = [
        { id: "PR-2026-001", title: "Lab Equipment — 20 Raspberry Pi 5", by: "Prof. Lakshmi P", amount: "₹1,20,000", date: "Feb 20", status: "pending" },
        { id: "PR-2026-002", title: "Conference Travel — IEEE ICML 2026", by: "Dr. Arun K", amount: "₹85,000", date: "Feb 18", status: "pending" },
        { id: "PR-2026-003", title: "Software Licenses — JetBrains", by: "Prof. Meera S", amount: "₹2,40,000", date: "Feb 15", status: "pending" },
        { id: "PR-2026-004", title: "Books — Database Internals (50 copies)", by: "Prof. Lakshmi P", amount: "₹45,000", date: "Feb 10", status: "approved" },
        { id: "PR-2026-005", title: "Projector Repair — Lab Hall 3", by: "Dr. Ravi V", amount: "₹12,000", date: "Feb 5", status: "approved" },
        { id: "PR-2026-006", title: "AWS Credits — Final Year Projects", by: "Dr. Suresh B", amount: "₹50,000", date: "Jan 30", status: "rejected" },
    ];
    const sc: Record<string, string> = { pending: "bg-amber-100 text-amber-700", approved: "bg-green-100 text-green-700", rejected: "bg-red-100 text-red-700" };
    return (
        <div><h1 className="text-2xl font-bold mb-6">Purchase Approvals</h1>
            <div className="bg-white rounded-2xl p-6 shadow-sm border"><table className="w-full"><thead className="bg-gray-50"><tr>{["ID", "Item", "Requested By", "Amount", "Date", "Status", "Action"].map(h => <th key={h} className="p-3 text-sm font-semibold text-left">{h}</th>)}</tr></thead>
                <tbody>{requests.map(r => (<tr key={r.id} className="border-t border-gray-100 hover:bg-gray-50"><td className="p-3 text-sm text-gray-500">{r.id}</td><td className="p-3 text-sm font-medium">{r.title}</td><td className="p-3 text-sm">{r.by}</td><td className="p-3 text-sm font-semibold">{r.amount}</td><td className="p-3 text-sm text-gray-500">{r.date}</td><td className="p-3"><span className={`px-2 py-1 rounded-md text-xs font-medium ${sc[r.status]}`}>{r.status}</span></td><td className="p-3">{r.status === "pending" && <div className="flex gap-2"><button className="px-3 py-1 bg-green-600 text-white rounded-lg text-xs font-medium hover:bg-green-700">Approve</button><button className="px-3 py-1 bg-red-100 text-red-600 rounded-lg text-xs font-medium hover:bg-red-200">Reject</button></div>}</td></tr>))}</tbody></table></div></div>
    );
}
