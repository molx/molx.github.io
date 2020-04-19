import React from "react"
import { Link } from "gatsby"
import headerStyles from "./header.module.css"

export default ({ children }) => (
    <div className={headerStyles.header}>
        <header>
            <h1>Alan Ribeiro Mól</h1>
        </header>
        <div className={"inner"}>
            <div className={headerStyles.nav}>
                <ul>
                    <Link to="/">
                        <li>Sobre</li>
                    </Link>
                    <Link to="/projetos">
                        <li>Projetos</li>
                    </Link>
                </ul>
            </div>
        </div>
    </div>
)
