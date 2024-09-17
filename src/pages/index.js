import * as React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import Projlink from "../components/projlink"
import Seo from "../components/SEO"

const Index = ({ data }) => {
    return (
        <Layout>
            <Seo title={"About - Alan Mól"} />
            <h2>About</h2>
            <img
                alt="Foto de Alan Mól"
                src={"img/alanmol.jpg"}
                style={{ float: "right", width: "15%", margin: "0 0 10px 2%", minWidth: "100px" }}
            />
            <p>
                I graduated in chemistry by the University of Brasília, Brazil, in 2010 and completed my master's degree in Analytical Chemistry in 2015.
                Since 2013 I work also at the University of Brasília as a chemist, currently at the Analytical Central of the Chemistry Institute,
                mainly working with chromatrography and mass spectrometry.
            </p>
            <p>
                Besides being a chemist, I also have a passion for computers and programming. I'm often involved in one or more projects
                in that area, some of them personal, some of them within communities.
            </p>
            <div className={"projparent"} style={{ clear: "both" }}>
                {data.allPerfisCsv.nodes.map(proj => (
                    <Projlink data={proj} />
                ))}
            </div>
        </Layout>
    )
}
export default Index;
export const query = graphql`
    query {
        allPerfisCsv {
            nodes {
                img
                name
                url
                desc
            }
        }
    }
`
