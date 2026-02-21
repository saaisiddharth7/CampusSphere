export default function DepartmentPage() {
    const sections = [
        { sec: "CSE-1A", students: 60, att: 85.2, cgpa: 7.9, pass: 96 },
        { sec: "CSE-1B", students: 58, att: 82.1, cgpa: 7.6, pass: 94 },
        { sec: "CSE-2A", students: 56, att: 80.5, cgpa: 7.4, pass: 92 },
        { sec: "CSE-2B", students: 54, att: 78.3, cgpa: 7.1, pass: 90 },
        { sec: "CSE-3A", students: 52, att: 82.3, cgpa: 7.8, pass: 95 },
        { sec: "CSE-3B", students: 48, att: 79.1, cgpa: 7.2, pass: 91 },
        { sec: "CSE-4A", students: 78, att: 86.1, cgpa: 8.0, pass: 97 },
        { sec: "CSE-4B", students: 74, att: 83.5, cgpa: 7.7, pass: 94 },
    ];
    const metrics = [
        { label: "Placement Rate", value: "90.0%", trend: "📈 +5.2%", icon: "💼" },
        { label: "Average Package", value: "₹8.2 LPA", trend: "📈 +1.1 LPA", icon: "💰" },
        { label: "Student-Teacher Ratio", value: "20:1", trend: "➡️ Stable", icon: "👥" },
        { label: "Fee Collection", value: "94.2%", trend: "📈 +2.3%", icon: "🏦" },
        { label: "Grievance Resolution", value: "88%", trend: "📈 +8%", icon: "🛡️" },
    ];
    return (
        <div>
            <h1 className="text-2xl font-bold mb-6">Department Analytics</h1>
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mb-8">
                <h2 className="text-lg font-bold mb-4">Section Comparison</h2>
                <table className="w-full">
                    <thead className="bg-gray-50"><tr>{["Section", "Students", "Att %", "Avg CGPA", "Pass %"].map(h => <th key={h} className="p-3 text-sm font-semibold text-left">{h}</th>)}</tr></thead>
                    <tbody>
                        {sections.map(s => (
                            <tr key={s.sec} className="border-t border-gray-100">
                                <td className="p-3 text-sm font-semibold">{s.sec}</td>
                                <td className="p-3 text-sm">{s.students}</td>
                                <td className="p-3 text-sm"><span className={`font-semibold ${s.att >= 80 ? "text-green-600" : s.att >= 75 ? "text-orange-600" : "text-red-600"}`}>{s.att}%</span></td>
                                <td className="p-3 text-sm">{s.cgpa}</td>
                                <td className="p-3 text-sm">{s.pass}%</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mb-8">
                <h2 className="text-lg font-bold mb-4">Attendance by Year</h2>
                <div className="space-y-4">
                    {[{ year: "1st Year", pct: 83.7 }, { year: "2nd Year", pct: 79.4 }, { year: "3rd Year", pct: 80.7 }, { year: "4th Year", pct: 84.8 }].map(y => (
                        <div key={y.year}><div className="flex justify-between mb-1"><span className="text-sm font-medium">{y.year}</span><span className={`text-sm font-bold ${y.pct >= 80 ? "text-green-600" : "text-orange-600"}`}>{y.pct}%</span></div><div className="w-full bg-gray-100 rounded-full h-2.5"><div className={`h-2.5 rounded-full ${y.pct >= 80 ? "bg-green-500" : "bg-orange-500"}`} style={{ width: `${y.pct}%` }} /></div></div>
                    ))}
                </div>
            </div>
            <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <h2 className="text-lg font-bold mb-4">Key Metrics</h2>
                <div className="grid grid-cols-5 gap-4">
                    {metrics.map(m => (<div key={m.label} className="text-center p-4 bg-gray-50 rounded-xl"><p className="text-2xl mb-1">{m.icon}</p><p className="text-xl font-bold">{m.value}</p><p className="text-xs text-gray-500">{m.label}</p><p className="text-xs mt-1">{m.trend}</p></div>))}
                </div>
            </div>
        </div>
    );
}
