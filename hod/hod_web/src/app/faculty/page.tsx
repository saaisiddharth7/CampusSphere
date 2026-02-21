export default function FacultyPage() {
    const faculty = [
        { name: "Prof. Lakshmi P", id: "FAC-042", spec: "Database Systems", teaching: 97, research: 3, feedback: 4.2, score: 8.5, speed: "2.1d" },
        { name: "Dr. Arun K", id: "FAC-015", spec: "AI/ML", teaching: 100, research: 5, feedback: 4.6, score: 9.1, speed: "1.5d" },
        { name: "Prof. Meera S", id: "FAC-028", spec: "Networks", teaching: 88, research: 2, feedback: 3.8, score: 7.2, speed: "3.5d" },
        { name: "Dr. Ravi V", id: "FAC-033", spec: "Cloud Computing", teaching: 95, research: 4, feedback: 4.4, score: 8.8, speed: "1.8d" },
        { name: "Prof. Sunitha M", id: "FAC-051", spec: "Data Science", teaching: 92, research: 6, feedback: 4.5, score: 8.9, speed: "2.0d" },
        { name: "Dr. Karthik N", id: "FAC-019", spec: "Cybersecurity", teaching: 90, research: 1, feedback: 3.5, score: 6.8, speed: "4.2d" },
        { name: "Prof. Deepa R", id: "FAC-064", spec: "Software Engg", teaching: 93, research: 3, feedback: 4.0, score: 8.1, speed: "2.3d" },
        { name: "Dr. Suresh B", id: "FAC-041", spec: "Theory of Comp", teaching: 85, research: 8, feedback: 4.1, score: 8.3, speed: "2.8d" },
    ];
    return (
        <div>
            <div className="flex items-center justify-between mb-6"><h1 className="text-2xl font-bold">Faculty Performance</h1><button className="px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-medium hover:bg-purple-700">📥 Export</button></div>
            <div className="grid grid-cols-3 gap-4 mb-8">
                <div className="bg-white rounded-2xl p-5 shadow-sm border text-center"><p className="text-2xl font-bold text-green-600">8.2</p><p className="text-sm text-gray-500">Avg Score</p></div>
                <div className="bg-white rounded-2xl p-5 shadow-sm border text-center"><p className="text-2xl font-bold text-purple-600">92.5%</p><p className="text-sm text-gray-500">Avg Teaching</p></div>
                <div className="bg-white rounded-2xl p-5 shadow-sm border text-center"><p className="text-2xl font-bold text-orange-600">4.1/5</p><p className="text-sm text-gray-500">Avg Feedback</p></div>
            </div>
            <div className="space-y-4">
                {faculty.map(f => (
                    <div key={f.id} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div className="flex items-center gap-4"><div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center text-purple-700 font-bold">{f.name.split(" ").map(w => w[0]).slice(0, 2).join("")}</div><div className="flex-1"><p className="font-bold">{f.name}</p><p className="text-sm text-gray-500">{f.id} • {f.spec}</p></div><span className={`px-4 py-2 rounded-xl text-lg font-bold ${f.score >= 8.5 ? "bg-green-100 text-green-700" : f.score >= 7.5 ? "bg-orange-100 text-orange-700" : "bg-red-100 text-red-700"}`}>{f.score}/10</span></div>
                        <div className="grid grid-cols-4 gap-3 mt-4">
                            <div className="text-center p-3 bg-gray-50 rounded-xl"><p className="text-sm font-bold">{f.teaching}%</p><p className="text-xs text-gray-500">Teaching</p></div>
                            <div className="text-center p-3 bg-gray-50 rounded-xl"><p className="text-sm font-bold">{f.research} papers</p><p className="text-xs text-gray-500">Research</p></div>
                            <div className="text-center p-3 bg-gray-50 rounded-xl"><p className="text-sm font-bold">{f.feedback}/5</p><p className="text-xs text-gray-500">Feedback</p></div>
                            <div className="text-center p-3 bg-gray-50 rounded-xl"><p className="text-sm font-bold">{f.speed}</p><p className="text-xs text-gray-500">Verify Speed</p></div>
                        </div>
                        <div className="mt-3 w-full bg-gray-100 rounded-full h-2"><div className={`h-2 rounded-full ${f.teaching >= 90 ? "bg-green-500" : "bg-orange-500"}`} style={{ width: `${f.teaching}%` }} /></div>
                    </div>
                ))}
            </div>
        </div>
    );
}
