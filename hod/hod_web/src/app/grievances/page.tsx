export default function GrievancesPage() {
    const grievances = [
        { id: "GRV-041", title: "Lab AC not working since 2 weeks", by: "Rahul Kumar (21CS101)", type: "Infrastructure", status: "escalated", date: "Feb 20" },
        { id: "GRV-039", title: "WiFi connectivity issues in Block C", by: "Priya Menon (21CS102)", type: "IT", status: "open", date: "Feb 18" },
        { id: "GRV-036", title: "Faculty not providing assignment feedback", by: "Deepika R (21CS104)", type: "Academic", status: "open", date: "Feb 15" },
        { id: "GRV-033", title: "Library books shortage for DBMS", by: "CSE-3A CR", type: "Academic", status: "resolved", date: "Feb 10" },
        { id: "GRV-030", title: "Projector malfunction in Room 204", by: "Prof. Karthik N", type: "Infrastructure", status: "resolved", date: "Feb 5" },
    ];
    const sc: Record<string, string> = { escalated: "bg-red-100 text-red-600", open: "bg-orange-100 text-orange-600", resolved: "bg-green-100 text-green-600" };
    return (
        <div><h1 className="text-2xl font-bold mb-6">Grievances</h1>
            <div className="bg-white rounded-2xl p-6 shadow-sm border"><table className="w-full"><thead className="bg-gray-50"><tr>{["ID", "Title", "Raised By", "Type", "Date", "Status", "Action"].map(h => <th key={h} className="p-3 text-sm font-semibold text-left">{h}</th>)}</tr></thead>
                <tbody>{grievances.map(g => (<tr key={g.id} className="border-t border-gray-100 hover:bg-gray-50"><td className="p-3 text-sm text-gray-500">{g.id}</td><td className="p-3 text-sm font-medium">{g.title}</td><td className="p-3 text-sm">{g.by}</td><td className="p-3 text-sm">{g.type}</td><td className="p-3 text-sm text-gray-500">{g.date}</td><td className="p-3"><span className={`px-2 py-1 rounded-md text-xs font-medium ${sc[g.status]}`}>{g.status === "escalated" ? "🔴 Escalated" : g.status}</span></td><td className="p-3">{g.status !== "resolved" && <div className="flex gap-2"><button className="px-3 py-1 bg-green-600 text-white rounded-lg text-xs">Resolve</button><button className="px-3 py-1 bg-orange-100 text-orange-600 rounded-lg text-xs">Escalate</button></div>}</td></tr>))}</tbody></table></div></div>
    );
}
