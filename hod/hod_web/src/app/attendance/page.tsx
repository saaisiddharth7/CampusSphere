export default function AttendancePage() {
    const sections = [
        { sec: "CSE-3A", faculty: "Prof. Lakshmi P", students: 52, present: 44, absent: 6, od: 2 },
        { sec: "CSE-3B", faculty: "Prof. Lakshmi P", students: 48, present: 38, absent: 8, od: 2 },
        { sec: "CSE-2A", faculty: "Dr. Ravi V", students: 56, present: 48, absent: 7, od: 1 },
        { sec: "CSE-2B", faculty: "Prof. Meera S", students: 54, present: 42, absent: 10, od: 2 },
        { sec: "CSE-1A", faculty: "Dr. Karthik N", students: 60, present: 52, absent: 6, od: 2 },
        { sec: "CSE-1B", faculty: "Prof. Deepa R", students: 58, present: 50, absent: 5, od: 3 },
        { sec: "CSE-4A", faculty: "Dr. Suresh B", students: 78, present: 68, absent: 8, od: 2 },
        { sec: "CSE-4B", faculty: "Dr. Arun K", students: 74, present: 62, absent: 10, od: 2 },
    ];
    return (
        <div><h1 className="text-2xl font-bold mb-6">Department Attendance</h1>
            <div className="grid grid-cols-5 gap-4 mb-8">{[{ l: "Total", v: "480" }, { l: "Present", v: "404" }, { l: "Absent", v: "60" }, { l: "OD", v: "16" }, { l: "Overall", v: "84.2%" }].map(s => <div key={s.l} className="bg-white rounded-2xl p-5 shadow-sm border text-center"><p className="text-2xl font-bold">{s.v}</p><p className="text-sm text-gray-500">{s.l}</p></div>)}</div>
            <div className="grid grid-cols-2 gap-4">{sections.map(s => {
                const pct = Math.round(s.present / s.students * 100); return (
                    <div key={s.sec} className="bg-white rounded-2xl p-5 shadow-sm border"><div className="flex justify-between items-center mb-1"><span className="font-bold">{s.sec}</span><span className={`font-bold text-lg ${pct >= 80 ? "text-green-600" : "text-orange-600"}`}>{pct}%</span></div><p className="text-sm text-gray-500 mb-3">{s.faculty}</p><div className="w-full bg-gray-100 rounded-full h-2.5 mb-3"><div className={`h-2.5 rounded-full ${pct >= 80 ? "bg-green-500" : "bg-orange-500"}`} style={{ width: `${pct}%` }} /></div><div className="flex gap-2"><span className="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium">P: {s.present}</span><span className="px-2 py-1 bg-red-100 text-red-700 rounded text-xs font-medium">A: {s.absent}</span><span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-xs font-medium">OD: {s.od}</span></div></div>)
            })}</div></div>
    );
}
