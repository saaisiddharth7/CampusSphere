export default function DashboardPage() {
    const stats = [
        { label: "Total Students", value: "480", icon: "👥", color: "bg-purple-100 text-purple-700" },
        { label: "Faculty Members", value: "24", icon: "👨‍🏫", color: "bg-teal-100 text-teal-700" },
        { label: "Avg Attendance", value: "82.3%", icon: "📈", color: "bg-orange-100 text-orange-700" },
        { label: "At-Risk Students", value: "12", icon: "⚠️", color: "bg-red-100 text-red-700" },
    ];
    const approvals = [
        { title: "Lab Equipment — 20 Raspberry Pi 5", by: "Prof. Lakshmi P", amount: "₹1,20,000" },
        { title: "Conference Travel — IEEE ICML", by: "Dr. Arun K", amount: "₹85,000" },
        { title: "Software Licenses — JetBrains", by: "Prof. Meera S", amount: "₹2,40,000" },
    ];
    const faculty = [
        { name: "Prof. Lakshmi P", score: 8.5, classes: "97%", feedback: "4.2/5" },
        { name: "Dr. Arun K", score: 9.1, classes: "100%", feedback: "4.6/5" },
        { name: "Prof. Meera S", score: 7.2, classes: "88%", feedback: "3.8/5" },
        { name: "Dr. Ravi V", score: 8.8, classes: "95%", feedback: "4.4/5" },
    ];
    return (
        <div>
            <h1 className="text-2xl font-bold mb-1">Good Evening, Dr. Venkat</h1>
            <p className="text-gray-500 mb-6">Computer Science & Engineering • HOD</p>
            <div className="grid grid-cols-4 gap-4 mb-8">
                {stats.map((s) => (
                    <div key={s.label} className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
                        <div className="flex items-center justify-between mb-2">
                            <span className={`w-10 h-10 rounded-xl flex items-center justify-center text-lg ${s.color}`}>{s.icon}</span>
                            <span className="text-2xl font-bold">{s.value}</span>
                        </div>
                        <p className="text-gray-500 text-sm">{s.label}</p>
                    </div>
                ))}
            </div>
            <div className="grid grid-cols-2 gap-6">
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <h2 className="text-lg font-bold mb-4">Pending Approvals</h2>
                    <div className="space-y-3">
                        {approvals.map((a) => (
                            <div key={a.title} className="flex items-center gap-4 p-3 bg-orange-50 rounded-xl">
                                <span className="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center">📋</span>
                                <div className="flex-1">
                                    <p className="text-sm font-semibold">{a.title}</p>
                                    <p className="text-xs text-gray-500">{a.by} • {a.amount}</p>
                                </div>
                                <span className="px-2 py-1 bg-amber-100 text-amber-700 rounded-md text-xs font-medium">Awaiting</span>
                            </div>
                        ))}
                    </div>
                </div>
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-red-100">
                    <h2 className="text-lg font-bold mb-4 text-red-600">🚨 Critical Alerts</h2>
                    <div className="bg-red-50 rounded-xl p-4">
                        <p className="text-sm font-bold text-red-700 mb-3">Dropout Risk — 12 Students</p>
                        {["Deepika R (21CS104) — Risk: 92%, Att: 48%", "Ganesh K (21CS107) — Risk: 87%, Att: 52%", "Meera S (21CS133) — Risk: 81%, 3 backlogs"].map((s) => (
                            <p key={s} className="text-sm text-red-800 mb-1">• {s}</p>
                        ))}
                    </div>
                </div>
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 col-span-2">
                    <h2 className="text-lg font-bold mb-4">Faculty Performance Snapshot</h2>
                    <table className="w-full">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="text-left p-3 text-sm font-semibold rounded-l-lg">Faculty</th>
                                <th className="text-center p-3 text-sm font-semibold">Classes</th>
                                <th className="text-center p-3 text-sm font-semibold">Feedback</th>
                                <th className="text-center p-3 text-sm font-semibold rounded-r-lg">Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            {faculty.map((f) => (
                                <tr key={f.name} className="border-t border-gray-100">
                                    <td className="p-3 text-sm font-medium">{f.name}</td>
                                    <td className="p-3 text-sm text-center">{f.classes}</td>
                                    <td className="p-3 text-sm text-center">{f.feedback}</td>
                                    <td className="p-3 text-center">
                                        <span className={`px-3 py-1 rounded-lg text-sm font-bold ${f.score >= 8.5 ? "bg-green-100 text-green-700" : f.score >= 7.5 ? "bg-orange-100 text-orange-700" : "bg-red-100 text-red-700"}`}>{f.score}/10</span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
