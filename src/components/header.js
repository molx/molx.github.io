import React from "react"
import { Link } from "gatsby"
import * as headerStyles from "./header.module.css"

const Header = () => (
    <div className={headerStyles.header}>
        <header>
            <h1>Alan Ribeiro Mól</h1>
        </header>
        <div className={"inner"}>
            <div className={headerStyles.nav}>
                <div>
                    <Link to="/" activeClassName={headerStyles.active}>
                        Sobre
                    </Link>
                </div>
                <div>
                    <Link to="/projetos" activeClassName={headerStyles.active}>
                        Projetos
                    </Link>
                </div>
                <div>
                    <Link to="/blog" activeClassName={headerStyles.active} partiallyActive={true}>
                        Blog
                    </Link>
                </div>
            </div>
        </div>
    </div>
)
export default Header;
