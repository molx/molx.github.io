"use strict";(self.webpackChunkgatsby_alanmol_com=self.webpackChunkgatsby_alanmol_com||[]).push([[711],{5288:function(e,t,a){var n=a(6540),l=a(6462),r=a(4794);const m=e=>{let{title:t,description:a,image:m,type:c}=e;const{pathname:o}=(0,l.useLocation)(),{site:s}=(0,r.useStaticQuery)(i),{defaultTitle:u,defaultDescription:d,siteUrl:p,defaultImage:E,twitterUsername:g,defaultType:v}=s.siteMetadata,y={title:t||u,description:a||d,image:`${p}${m||E}`,url:`${p}${o}`,type:c||v};return n.createElement(n.Fragment,null,n.createElement("title",null,y.title),n.createElement("meta",{name:"description",content:y.description}),n.createElement("meta",{name:"image",content:y.image}),y.url&&n.createElement("meta",{property:"og:url",content:y.url}),y.type&&n.createElement("meta",{property:"og:type",content:y.type}),y.title&&n.createElement("meta",{property:"og:title",content:y.title}),y.description&&n.createElement("meta",{property:"og:description",content:y.description}),y.image&&n.createElement("meta",{property:"og:image",content:y.image}),n.createElement("meta",{name:"twitter:card",content:"summary_large_image"}),g&&n.createElement("meta",{name:"twitter:creator",content:g}),y.title&&n.createElement("meta",{name:"twitter:title",content:y.title}),y.description&&n.createElement("meta",{name:"twitter:description",content:y.description}),y.image&&n.createElement("meta",{name:"twitter:image",content:y.image}))};t.A=m,m.defaultProps={title:"Alan Mól",description:null,image:null,article:!1};const i="1500388132"},2550:function(e,t,a){a.d(t,{A:function(){return i}});var n=a(6540),l=a(4794),r="header-module--active--6bd37";var m=()=>n.createElement("div",{className:"header-module--header--666b3"},n.createElement("header",null,n.createElement("h1",null,"Alan Ribeiro Mól")),n.createElement("div",{className:"inner"},n.createElement("div",{className:"header-module--nav--7bc38"},n.createElement("div",null,n.createElement(l.Link,{to:"/",activeClassName:r},"About")),n.createElement("div",null,n.createElement(l.Link,{to:"/projetos",activeClassName:r},"Projects")),n.createElement("div",null,n.createElement(l.Link,{to:"/blog",activeClassName:r,partiallyActive:!0},"Blog")))));var i=e=>{let{children:t}=e;return n.createElement("div",{className:"site"},n.createElement(m,null),n.createElement("div",{id:"main_content"},n.createElement("div",{className:"inner"},t)),n.createElement("footer",null))}},4151:function(e,t,a){a.r(t);var n=a(6540),l=a(4794),r=a(2550),m=a(5288);t.default=e=>{let{data:t}=e;return n.createElement("div",null,n.createElement(r.A,null,n.createElement(m.A,{title:"Blog - Alan Mól"}),n.createElement("h2",null,"Últimos posts"),t.allMarkdownRemark.edges.map((e=>{let{node:t}=e;return n.createElement("div",{key:t.id,style:{marginTop:"2em"}},n.createElement(l.Link,{to:"/blog/"+t.frontmatter.slug,style:{color:"#000"}},n.createElement("h4",null,t.frontmatter.title,n.createElement("br",null),n.createElement("span",{style:{fontSize:"0.8em"}},t.frontmatter.date)),n.createElement("p",null,t.excerpt)),n.createElement("hr",null))}))))}}}]);
//# sourceMappingURL=component---src-pages-blog-js-23a9a96cea1d8ecf8dc5.js.map