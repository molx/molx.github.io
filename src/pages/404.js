import React from "react"
import Layout from "../components/layout"

export default ({ data }) => {
    console.log(data)
    return (
        <div>
            <Layout>
                <p style={{ "font-size": "3em" }}>404</p>
                <p>Ops! Essa página não existe. :(</p>
            </Layout>
        </div>
    )
}
