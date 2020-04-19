import React from "react"
import Header from "../components/header"
/* import layoutStyles from "./layout.module.css" */

export default ({ children }) => (
    <div className={"site"}>
        <Header></Header>
        <div id="main_content">
            <div className={"inner"}>{children}</div>
        </div>
        <footer></footer>
    </div>
)
