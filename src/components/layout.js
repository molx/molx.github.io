import * as React from "react"
import Header from "../components/header"
import Seo from "../components/SEO"

/* import layoutStyles from "./layout.module.css" */

const Layout = ({ children }) => (
    <div className={"site"}>
        <Seo />
        <Header />
        <div id="main_content">
            <div className={"inner"}>{children}</div>
        </div>
        <footer></footer>
    </div>
)
export default Layout;

export function Head() {
    return (
        <>
            <meta charset="utf-8" />
            <html lang="pt" />
            <link rel="canonical" href="http://alanmol.com.br/" />
        </>
    )
}