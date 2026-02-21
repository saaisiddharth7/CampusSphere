export default function ProfilePage() {
    return (
        <div className="max-w-2xl mx-auto"><h1 className="text-2xl font-bold mb-6">Profile</h1>
            <div className="bg-white rounded-2xl p-8 shadow-sm border text-center mb-6"><div className="w-20 h-20 rounded-full bg-gradient-to-br from-purple-600 to-purple-400 flex items-center justify-center text-white text-2xl font-bold mx-auto mb-4">VR</div><h2 className="text-xl font-bold">Dr. Venkat R</h2><p className="text-gray-500">Professor & Head</p><p className="text-sm text-gray-400">Computer Science & Engineering • FAC-001</p></div>
            <div className="bg-white rounded-2xl p-6 shadow-sm border mb-6"><h3 className="font-bold mb-4">Academic Details</h3><div className="space-y-3">
                {[{ icon: "🎓", label: "Qualification", value: "Ph.D. CSE (IIT Madras)" }, { icon: "🔬", label: "Specialization", value: "Machine Learning & Data Science" }, { icon: "⏱️", label: "Experience", value: "18 years" }, { icon: "👨‍🏫", label: "Faculty Under", value: "24 members" }, { icon: "👥", label: "Students", value: "480 across 8 sections" }, { icon: "📧", label: "Email", value: "venkat.r@campussphere.demo" }, { icon: "📱", label: "Phone", value: "9876500100" }].map(d => (<div key={d.label} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl"><span className="text-lg">{d.icon}</span><div><p className="text-xs text-gray-500">{d.label}</p><p className="text-sm font-semibold">{d.value}</p></div></div>))}</div></div>
            <div className="bg-white rounded-2xl p-6 shadow-sm border"><h3 className="font-bold mb-4">Settings</h3><div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-xl"><span className="text-sm">🌙 Dark Mode</span><div className="w-10 h-6 bg-gray-300 rounded-full relative"><div className="w-4 h-4 bg-white rounded-full absolute top-1 left-1" /></div></div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-xl"><span className="text-sm">🔔 Notifications</span><div className="w-10 h-6 bg-purple-600 rounded-full relative"><div className="w-4 h-4 bg-white rounded-full absolute top-1 right-1" /></div></div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-xl"><span className="text-sm">🌐 Language</span><span className="text-sm text-gray-500">English</span></div></div>
                <button className="mt-6 w-full py-3 border-2 border-red-200 text-red-600 rounded-xl font-medium hover:bg-red-50 transition">Sign Out</button></div></div>
    );
}
