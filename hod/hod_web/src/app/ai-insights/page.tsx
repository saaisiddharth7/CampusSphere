export default function AiInsightsPage() {
    return (
        <div><div className="flex items-center justify-between mb-6"><h1 className="text-2xl font-bold">AI Insights</h1><button className="px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-medium hover:bg-purple-700">📥 Export</button></div>
            <div className="grid grid-cols-4 gap-4 mb-8">
                {[{ label: "Low Risk\n0-20%", count: 156, color: "border-green-500 text-green-600" }, { label: "Moderate\n20-50%", count: 52, color: "border-orange-500 text-orange-600" }, { label: "High\n50-75%", count: 22, color: "border-orange-600 text-orange-700" }, { label: "Critical\n75-100%", count: 10, color: "border-red-500 text-red-600" }].map(r => (<div key={r.label} className={`bg-white rounded-2xl p-5 shadow-sm border-l-4 ${r.color} text-center`}><p className="text-3xl font-bold">{r.count}</p><p className="text-xs text-gray-500 whitespace-pre-line mt-1">{r.label}</p></div>))}
            </div>
            <div className="grid grid-cols-2 gap-6">
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-red-100"><h2 className="text-lg font-bold text-red-600 mb-4">🚨 Critical Risk Students</h2><div className="space-y-3">
                    {[{ name: "Deepika R", roll: "21CS104", risk: 92, factors: "Att: 48%, CGPA: 4.2" }, { name: "Ganesh K", roll: "21CS107", risk: 87, factors: "Att: 52%, 3 backlogs" }, { name: "Meera S", roll: "21CS133", risk: 81, factors: "Att: 58%, Fee default" }, { name: "Vijay T", roll: "21CS145", risk: 78, factors: "Att: 62%, 2 backlogs" }].map(s => (<div key={s.roll} className="flex items-center gap-4 p-3 bg-red-50 rounded-xl"><div className="w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center text-sm font-bold">{s.risk}%</div><div className="flex-1"><p className="text-sm font-semibold">{s.name}</p><p className="text-xs text-gray-500">{s.roll} • {s.factors}</p></div></div>))}</div></div>
                <div className="bg-white rounded-2xl p-6 shadow-sm border"><h2 className="text-lg font-bold mb-4">📋 Recommended Actions</h2><div className="space-y-3">
                    {["📞 Contact parent/guardian for 10 critical risk students", "📅 Schedule counselor meetings for 22 high-risk", "🎓 Check scholarship eligibility for 5 fee defaulters", "📄 Create recovery plans for top 15 at-risk"].map(a => (<div key={a} className="p-3 bg-gray-50 rounded-xl text-sm">{a}</div>))}</div></div>
                <div className="bg-white rounded-2xl p-6 shadow-sm border col-span-2"><h2 className="text-lg font-bold mb-4">📊 Department Trends</h2><div className="grid grid-cols-5 gap-4">
                    {[{ l: "Avg Attendance", v: "82.3%", t: "📉 -1.8%" }, { l: "Assignments", v: "84.2%", t: "➡️ Stable" }, { l: "Engagement", v: "72.1%", t: "📈 +5.3%" }, { l: "Meetings", v: "68.4%", t: "📉 -3.1%" }, { l: "Placement", v: "90.0%", t: "📈 +5.2%" }].map(m => (<div key={m.l} className="text-center p-4 bg-gray-50 rounded-xl"><p className="text-xl font-bold">{m.v}</p><p className="text-xs text-gray-500">{m.l}</p><p className="text-xs mt-1">{m.t}</p></div>))}</div></div>
            </div></div>
    );
}
