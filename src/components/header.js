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
                    <li>
                        <Link to="/" activeClassName={headerStyles.active}>
                            Sobre
                        </Link>
                    </li>
                    <li>
                        <Link to="/projetos" activeClassName={headerStyles.active}>
                            Projetos
                        </Link>
                    </li>
                    <li>
                        <Link to="/blog" activeClassName={headerStyles.active} partiallyActive={true}>
                            Blog
                        </Link>
                    </li>
                </ul>
            </div>
        </div>
    </div>
)
