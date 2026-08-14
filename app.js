
const categories = [
  ["الشاشات","LCD / OLED / Touch","📱"],["البطاريات","رقم البطارية والتوافقات","🔋"],
  ["الكاميرات","أمامية وخلفية","📷"],["الشحن","بورد وفلاتة ومنفذ الشحن","⚡"],
  ["السماعات","Earpiece / Loudspeaker","🔊"],["المايكروفون","Mic / Flex / Modules","🎙️"],
  ["الفلاتات","Power / Volume / Main Flex","〰️"],["البصمة","Fingerprint Modules","☝️"],
  ["الظهر والفريم","Back Cover / Housing","▣"],["اللزقات","Screen / Battery / Back Adhesive","▦"],
  ["الشواحن","Adapters / Protocols","🔌"],["الكابلات","USB-C / Lightning وغيرها","🔗"]
];

const parts = [
  {category:"الشاشات",device:"iPhone 13",model:"A2633 / A2482",part:"شاشة OLED",compatible:"iPhone 13"},
  {category:"الشاشات",device:"Samsung Galaxy A52",model:"SM-A525F",part:"شاشة AMOLED",compatible:"A52 4G"},
  {category:"البطاريات",device:"iPhone 12",model:"A2403",part:"بطارية",compatible:"iPhone 12 / 12 Pro"},
  {category:"الكاميرات",device:"iPhone 11",model:"A2221",part:"كاميرا خلفية",compatible:"iPhone 11"},
  {category:"الشحن",device:"Samsung A32",model:"SM-A325F",part:"بورد شحن",compatible:"A32 4G"},
  {category:"البصمة",device:"Poco X3 NFC",model:"M2007J20CG",part:"بصمة جانبية",compatible:"Poco X3 NFC"},
  {category:"الشواحن",device:"Samsung S23",model:"SM-S911B",part:"شاحن PD",compatible:"USB-C PD 25W"},
  {category:"الكابلات",device:"iPhone 15",model:"A3090",part:"كيبل USB-C",compatible:"USB-C PD"}
];

let selectedCategory = null;
const categoryGrid = document.getElementById("categoryGrid");
const resultsGrid = document.getElementById("resultsGrid");
const emptyState = document.getElementById("emptyState");
const resultCount = document.getElementById("resultCount");
const searchInput = document.getElementById("searchInput");
const resultsSubtitle = document.getElementById("resultsSubtitle");

function renderCategories(){
  categoryGrid.innerHTML="";
  categories.forEach(([title,sub,icon])=>{
    const b=document.createElement("button");
    b.className="category-card"+(selectedCategory===title?" active":"");
    b.innerHTML=`<div class="category-icon">${icon}</div><h4>${title}</h4><p>${sub}</p>`;
    b.onclick=()=>{selectedCategory=selectedCategory===title?null:title;renderCategories();renderResults();document.getElementById("resultsSection").scrollIntoView({behavior:"smooth"});};
    categoryGrid.appendChild(b);
  });
}

function renderResults(){
  const q=searchInput.value.trim().toLowerCase();
  const filtered=parts.filter(p=>{
    const byCat=!selectedCategory||p.category===selectedCategory;
    const text=`${p.category} ${p.device} ${p.model} ${p.part} ${p.compatible}`.toLowerCase();
    return byCat&&(!q||text.includes(q));
  });
  resultsGrid.innerHTML="";
  filtered.forEach(p=>{
    const d=document.createElement("article");
    d.className="result-card";
    d.innerHTML=`<span class="tag">${p.category}</span><h4>${p.device}</h4><div class="model">${p.model}</div><div>${p.part}</div><div class="compat"><span>التوافق</span><strong>${p.compatible}</strong></div>`;
    resultsGrid.appendChild(d);
  });
  emptyState.hidden=filtered.length!==0;
  resultCount.textContent=`${filtered.length} نتيجة`;
  resultsSubtitle.textContent=selectedCategory?`قسم: ${selectedCategory}`:(q?`نتائج البحث عن: ${searchInput.value}`:"أحدث التوافقات المضافة");
}

searchInput.addEventListener("input",renderResults);
document.getElementById("clearBtn").onclick=()=>{searchInput.value="";selectedCategory=null;renderCategories();renderResults();};
document.getElementById("showAllBtn").onclick=()=>{searchInput.value="";selectedCategory=null;renderCategories();renderResults();};
document.getElementById("themeBtn").onclick=()=>document.body.classList.toggle("dark");
document.getElementById("cameraBtn").onclick=()=>{
  document.getElementById("cameraHint").style.display="block";
  const t=document.getElementById("toast");t.textContent="ميزة الكاميرا نربطها لاحقًا";t.classList.add("show");setTimeout(()=>t.classList.remove("show"),2200);
};
renderCategories();renderResults();
