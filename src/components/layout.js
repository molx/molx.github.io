import React from "react"
import { Helmet } from "react-helmet"
import Header from "../components/header"
/* import layoutStyles from "./layout.module.css" */

export default ({ children }) => (
    <div className={"site"}>
        <Helmet>
            <meta charSet="utf-8" />
            <title>Alan Mól</title>
            <link rel="canonical" href="http://alanmol.com.br/" />
            <meta property="og:image" content={"img/alanmol.jpg"} />
            <meta property="og:url" content="http://alanmol.com.br/" />
            <meta property="og:description" content="Site pessoal de Alan Mól." />
            <meta property="og:locale" content="pt_BR" />
            <meta property="og:type" content="website" />
        </Helmet>
        <Header></Header>
        <div id="main_content">
            <div className={"inner"}>{children}</div>
        </div>
        <footer></footer>
    </div>
)
