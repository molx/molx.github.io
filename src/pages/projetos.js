import * as React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import Projlink from "../components/projlink"
import Seo from "../components/SEO"

const Projetos = ({ data }) => {
    return (
        <div>
            <Layout>
                <Seo title={"Projetos"} />
                <h2>Projetos</h2>
                <p>
                    I have always enjoyed adventuring myself in the world of programming, and slowly learned
                    some things about development. Here you can also find the links to some of the projects
                    I have been involved with over these years.
                </p>
                <div className={"projparent"}>
                    {data.allProjetosCsv.nodes.map(proj => (
                        <Projlink data={proj} />
                    ))}
                </div>
            </Layout>
        </div>
    )
}
export default Projetos;
export const query = graphql`
    query {
        allProjetosCsv {
            nodes {
                img
                name
                url
                desc
            }
        }
    }
`
