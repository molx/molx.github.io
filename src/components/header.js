import React from "react"
import { Link } from "gatsby"
import headerStyles from "./header.module.css"

export default () => (
    <div className={headerStyles.header}>
        <header>
            <h1>Alan Ribeiro Mól</h1>
        </header>
        <div className={"inner"}>
            <div className={headerStyles.nav}>
                <ul>
                    <Link to="/" activeClassName={headerStyles.active}>
                        <li>Sobre</li>
                    </Link>
                    <Link to="/projetos" activeClassName={headerStyles.active}>
                        <li>Projetos</li>
                    </Link>
                    <Link to="/blog" activeClassName={headerStyles.active} partiallyActive={true}>
                        <li>Blog</li>
                    </Link>
                </ul>
            </div>
        </div>
    </div>
)
